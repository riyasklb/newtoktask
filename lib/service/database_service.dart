import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/model/users_profile.dart';
import 'package:newtoktask/service/auth_service.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  CollectionReference<UserProfile>? _usersCollection;
  late AuthService _authService;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  DatabaseService() {
    _authService = _getIt.get<AuthService>();
    _setupCollectionPreferences();
  }

  void _setupCollectionPreferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (UserProfile userProfile, _) => userProfile.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Future<UserProfile?> getUserProfileByUid(String uid) async {
    try {
      final docSnapshot = await _usersCollection?.doc(uid).get();
      if (docSnapshot != null && docSnapshot.exists) {
        return docSnapshot.data();  // Returns the UserProfile object
      }
      return null;
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _usersCollection!
        .where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots();
  }
}
