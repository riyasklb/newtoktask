import 'package:delightful_toast/delight_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/navigation_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _UserPageState();
}

class _UserPageState extends State<AdminPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late AlertService _alertService;

  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN'),
        actions: [
          IconButton(
            onPressed: () async {
              // Call the logout method
              bool result = await _authService.logout();

              if (result) {
                // Clear any local variables or data
                _clearLocalData();

                // Navigate to the login page
                _navigationService.pushReplacementNamed("/login");
                

                // Show a success message
                _alertService.showToast(
                    text: 'User logged out successfully', icon: Icons.check);
              } else {
                // Show an error message if logout fails
                _alertService.showToast(
                    text: 'Logout failed, please try again', icon: Icons.error);
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
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _profileList(),
          ],
        ),
      ),
    );
  }

  Widget _profileList() {
    return Column(children: [Text('')]);
  }

  // Method to clear local data
  void _clearLocalData() {
    // Clear any local storage, caches, or data here
    // Example:
    // _authService.clearUserData();
    // _databaseService.clearCache();
  }
}
