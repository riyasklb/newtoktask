import 'package:flutter/material.dart';
import 'package:newtoktask/pages/admin_page.dart';
import 'package:newtoktask/pages/user_page.dart';
import 'package:newtoktask/pages/login_page.dart';
import 'package:newtoktask/pages/register_page.dart';
import 'package:newtoktask/pages/splash_screen.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    "/userHome": (context) => UserPage(),
    '/adminHome': (context) => AdminPage(),
    "/registration": (context) => RegisterPage(),
    "/splash": (context) => SplashScreen(), // Add SplashScreen route
  };

  GlobalKey<NavigatorState>? get navigatorkey {
    return _navigatorkey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigationService() {
    _navigatorkey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    _navigatorkey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorkey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorkey.currentState?.pop();
  }
}
