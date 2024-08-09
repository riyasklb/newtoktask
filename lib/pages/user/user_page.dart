import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/navigation_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
        title: Text('User'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _navigationService.pushReplacementNamed("/login");
                _alertService.showToast(
                    text: 'User Logout Successfully', icon: Icons.check);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buidUI(),
    );
  }

  Widget _buidUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            _profilelist(),
          ],
        ),
      ),
    );
  }

  Widget _profilelist() {
    return Column(
      children: [
        InkWell(
            onTap: () {
              _navigationService.pushNamed('/countylistpage');
            },
            child: Text('users data')),
    InkWell(onTap:()=> _navigationService.pushNamed('/uploadexelpage'),
      child: SizedBox(height: 50,child: Text('upload file'),))  ],
    );
  }
}
