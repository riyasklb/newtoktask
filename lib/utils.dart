

import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/firebase_options.dart';
import 'package:newtoktask/service/alert_service.dart';
import 'package:newtoktask/service/auth_service.dart';
import 'package:newtoktask/service/database_service.dart';
import 'package:newtoktask/service/media_service%20.dart';
import 'package:newtoktask/service/navigation_service.dart';
import 'package:newtoktask/service/storge_service.dart';

Future<void> setupfirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AppCheckProvider.debug,
  //   webRecaptchaSiteKey: 'your-web-recaptcha-site-key',
  // );
}



  



Future<void> registerservice() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );

  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );

  getIt.registerSingleton<AlertService>(
    AlertService(),
  );


    getIt.registerSingleton<MediaService>(
    MediaService(),
  );

  getIt.registerSingleton<StorgeService>(
    StorgeService(),
  );


   getIt.registerSingleton<DatabaseService>(
    DatabaseService(),
  );
}
