import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/pages/auth/splash_screen.dart';
import 'package:newtoktask/utils.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  late NavigationService _navigationService;

  MyApp({super.key}) {
    _navigationService = getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorkey,
      title: 'Video Player',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),  // Set SplashScreen as the home widget
      routes: _navigationService.routes,
    );
  }
}
