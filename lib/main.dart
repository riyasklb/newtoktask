import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/pages/auth/splash_screen.dart';
import 'package:newtoktask/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  registerServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = GetIt.instance.get<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorKey,
      title: 'Video Player',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: _navigationService.routes,
    );
  }
}
