import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/navigation_service.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key}); // Added key for consistency

  @override
  Widget build(BuildContext context) {
    // Trigger redirection logic after build is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirection(context);
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _handleRedirection(BuildContext context) async {
    final getIt = GetIt.instance;
    final authService = getIt.get<AuthService>();
    final databaseService = getIt.get<DatabaseService>();
    final navigationService = getIt.get<NavigationService>();

    final user = authService.user; // Retrieve current user from AuthService

    if (user == null) {
      // No user is logged in, redirect to login page
      navigationService.pushReplacementNamed('/login');
    } else {
      // User is logged in, fetch the user profile
      try {
        final userProfile = await databaseService.getUserProfileByUid(user.uid);

        if (userProfile != null && userProfile.role == 'Admin') {
          // User is an admin
          print('--------------------${userProfile.role}---------------------');
          navigationService.pushReplacementNamed('/adminHome');
        } else {
         
          // User is a regular userr
          navigationService.pushReplacementNamed('/userHome');
        }
      } catch (e) {
        // Handle any errors that might occur during fetching user profile
        print('Error fetching user profile: $e');
        navigationService.pushReplacementNamed('/login');
      }
    }
  }
}
