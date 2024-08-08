
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:newtoktask/model/users_profile.dart';
import 'package:newtoktask/service/auth_service.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  CollectionReference? _usersCollection;
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
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userprofile}) async {
    await _usersCollection?.doc(userprofile.uid).set(userprofile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }
}
