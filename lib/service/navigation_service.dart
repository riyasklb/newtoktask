import 'package:flutter/material.dart';
import 'package:newtoktask/pages/admin/admin_page.dart';
import 'package:newtoktask/pages/admin/location_selection_page.dart';
import 'package:newtoktask/pages/user/country_list_page.dart';
import 'package:newtoktask/pages/user/upload_exel_page.dart';
import 'package:newtoktask/pages/user/user_page.dart';
import 'package:newtoktask/pages/auth/login_page.dart';
import 'package:newtoktask/pages/auth/register_page.dart';
import 'package:newtoktask/pages/auth/splash_screen.dart';
import 'package:newtoktask/pages/user/weather_page.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, Widget Function(BuildContext)> routes = {
    "/login": (context) => LoginPage(),
    "/userHome": (context) => UserPage(),
    "/adminHome": (context) => AdminPage(),
    "/registration": (context) => RegisterPage(),
    "/splash": (context) => SplashScreen(),
    "/addlocationpage": (context) => AddLocationScreen(),
    "/countylistpage": (context) => LocationListScreen(),
    "/uploadexelpage": (context) => ExcelParserScreen(),
    "/weatherpage": (context) => WeatherPage(city: ''),
  };

  void pushNamed(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
