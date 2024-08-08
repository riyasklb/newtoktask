import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? _user;
  User? get user {
    return _user;
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthService() {
    // _firebaseAuth.authStateChanges().listen(autostatechengerstreamlisener);
  }
  Future<bool> login(String email, String password) async {
    try {
      final cridental = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cridental.user != null) {
        _user = cridental.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }







    Future<bool> register(String email, String password) async {
    try {
      final cridental = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (cridental.user != null) {
        _user = cridental.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }


  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

//  void autostatechengerstreamlisener(User? user) {
//     if (user != null) {
//       _user = user;
//     } else {
//       _user = null;
//     }
//   }
}
