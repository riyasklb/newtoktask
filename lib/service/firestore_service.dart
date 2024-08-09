import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a location to Firestore
  Future<void> addLocation(String country, String state, String district, String city) async {
    await _db.collection('locations').add({
      'country': country,
      'state': state,
      'district': district,
      'city': city,
    });
  }

   // Get all locations from Firestore
  Future<List<QueryDocumentSnapshot>> getAllLocations() async {
    QuerySnapshot snapshot = await _db.collection('locations').get();
    return snapshot.docs;
  }

  // // Bulk add locations from a list of maps
  // Future<void> addLocations(List<Map<String, String>> locations) async {
  //   WriteBatch batch = _db.batch();

  //   for (var location in locations) {
  //     batch.set(_db.collection('locations').doc(), location);
  //   }

  //   await batch.commit();
  // }

  // // Parse Excel file and return a list of location maps
  // Future<List<Map<String, String>>> parseExcelFile(Uint8List bytes) async {

  //   List<Map<String, String>> locations = [];

  //   for (var table in excel.tables.keys) {
  //     var sheet = excel.tables[table];
  //     if (sheet == null) continue;

  //     for (var row in sheet.rows) {
  //       if (row.isEmpty) continue;

  //       var location = {
  //         'country': (row[0] as String?) ?? '',
  //         'state': (row[1] as String?) ?? '',
  //         'district': (row[2] as String?) ?? '',
  //         'city': (row[3] as String?) ?? '',
  //       };

  //       // Check if location is not empty
  //       if (location.values.any((value) => (value as String).isNotEmpty)) {
  //         locations.add(location);
  //       }
  //     }
  //   }
  //   return locations;
  // }
}
