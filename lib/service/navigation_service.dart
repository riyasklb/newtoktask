import 'package:flutter/material.dart';
import 'package:newtoktask/pages/admin/admin_page.dart';
import 'package:newtoktask/pages/admin/location_selection_page.dart';
import 'package:newtoktask/pages/user/country_list_page.dart';
import 'package:newtoktask/pages/user/upload_exel_page.dart';
import 'package:newtoktask/pages/user/user_page.dart';
import 'package:newtoktask/pages/auth/login_page.dart';
import 'package:newtoktask/pages/auth/register_page.dart';
import 'package:newtoktask/pages/auth/splash_screen.dart';


class NavigationService {
  late GlobalKey<NavigatorState> _navigatorkey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    "/userHome": (context) => UserPage(),
    '/adminHome': (context) => AdminPage(),
    "/registration": (context) => RegisterPage(),
    "/splash": (context) => SplashScreen(), // Add SplashScreen route
    "/addlocationpage": (context) => AddLocationScreen(),
    "/countylistpage":(context)=>LocationListScreen(),
    "/uploadexelpage":(context)=>ExcelParserScreen(),
  
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
