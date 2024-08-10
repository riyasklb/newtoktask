import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/firestore_service.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/service/storge_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _output = '';

  String? _profilePictureUrl;

  final FirestoreService _firestoreService = FirestoreService();
  final StorgeService _storgeService = StorgeService();
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late AlertService _alertService;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();

    _loadUserProfile();
  }

   Future<void> _loadUserProfile() async {
    _currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      final userProfile = await _databaseService.getUserProfileByUid(_currentUser!.uid);
      setState(() {
        _profilePictureUrl = userProfile?.pfpURL;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
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
          if (country.isNotEmpty &&
              state.isNotEmpty &&
              district.isNotEmpty &&
              city.isNotEmpty) {
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
      _alertService.showToast(
        text: 'Data uploaded successfully!',
        icon: Icons.check,
      );
      _navigationService.pushNamed("/countylistpage");
      setState(() {
        _output = 'Data uploaded successfully!';
      });
    } else {
      _alertService.showToast(
        text: 'No file selected',
        icon: Icons.error,
      );
      print('No file selected');
    }
  }

  String _getCellValue(Data? cell) {
    if (cell == null || cell.value == null) return '';
    return cell.value.toString().trim();
  }

  Future<void> _uploadDataToFirestore(
      List<Map<String, String>> locationData) async {
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
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text('User Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _navigationService.pushReplacementNamed("/login");
                _alertService.showToast(
                    text: 'Logged out successfully', icon: Icons.check);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to your dashboard!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20),
            _isLoading ? _buildLoader() : _buildProfileSection(),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildActionButtons(),
                  if (_output.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _output,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: _profilePictureUrl != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(_profilePictureUrl!),
                radius: 40,
              )
            : CircleAvatar(
                child: Icon(Icons.person, size: 40, color: Colors.white),
                backgroundColor: Colors.blueAccent,
                radius: 40,
              ),
        title: Text(
         'User',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        subtitle: Text(
        _currentUser?.email ?? 'No email',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
                fontSize: 16,
              ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          'View Added Locations',
          Icons.list_alt,
          () {
            _navigationService.pushNamed('/countylistpage');
          },
        ),
        SizedBox(height: 16),
        _buildActionButton(
          'Upload Excel File',
          Icons.upload_file,
          pickExcelFile,
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
