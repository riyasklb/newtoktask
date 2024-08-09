import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/navigation_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirection(context);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Your App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'We are setting things up for you...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRedirection(BuildContext context) async {
    final authService = GetIt.instance.get<AuthService>();
    final databaseService = GetIt.instance.get<DatabaseService>();
    final navigationService = GetIt.instance.get<NavigationService>();

    final user = authService.user;

    if (user == null) {
      navigationService.pushReplacementNamed('/login');
    } else {
      try {
        final userProfile = await databaseService.getUserProfileByUid(user.uid);

        if (userProfile?.role == 'Admin') {
          navigationService.pushReplacementNamed('/adminHome');
        } else {
          navigationService.pushReplacementNamed('/userHome');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
        navigationService.pushReplacementNamed('/login');
      }
    }
  }
}
