import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:newtoktask/service/firestore_service.dart';

class ExcelParserScreen extends StatefulWidget {
  @override
  _ExcelParserScreenState createState() => _ExcelParserScreenState();
}

class _ExcelParserScreenState extends State<ExcelParserScreen> {
  String _output = '';
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> pickExcelFile() async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'Excel',
      extensions: ['xlsx'],
    );

    final XFile? pickedFile = await openFile(acceptedTypeGroups: [typeGroup]);

    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, String>> locationData = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet == null) continue;

        bool isHeader = true;
        for (var row in sheet.rows) {
          if (isHeader) {
            isHeader = false; // Skip the first row (header)
            continue;
          }

          if (row.isEmpty || row.length < 4) continue;

          String country = _getCellValue(row[0]);
          String state = _getCellValue(row[1]);
          String district = _getCellValue(row[2]);
          String city = _getCellValue(row[3]);

          // Validate non-empty values
          if (country.isNotEmpty && state.isNotEmpty && district.isNotEmpty && city.isNotEmpty) {
            locationData.add({
              'Country': country,
              'State': state,
              'District': district,
              'City': city,
            });
          }
        }
      }

      // Upload location data to Firestore
      await _uploadDataToFirestore(locationData);

      setState(() {
        _output = 'Data uploaded successfully!';
      });
    } else {
      print('No file selected');
    }
  }

  // Extract the plain text value from the cell
  String _getCellValue(Data? cell) {
    if (cell == null || cell.value == null) return '';
    return cell.value.toString().trim();
  }

  Future<void> _uploadDataToFirestore(List<Map<String, String>> locationData) async {
    for (var location in locationData) {
      await _firestoreService.addLocation(
        location['Country'] ?? '',
        location['State'] ?? '',
        location['District'] ?? '',
        location['City'] ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Parser'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickExcelFile,
              child: Text('Pick Excel File'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 14, fontFamily: 'Monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
