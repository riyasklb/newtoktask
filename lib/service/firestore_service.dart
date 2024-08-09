import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a location to Firestore
  Future<void> addLocation(String country, String state, String district, String city) async {
    await _db.collection('locations').add({
      'country': country,
      'state': state,
      'district': district,
      'city': city,
    });
  }

   // Get all locations from Firestore
  Future<List<QueryDocumentSnapshot>> getAllLocations() async {
    QuerySnapshot snapshot = await _db.collection('locations').get();
    return snapshot.docs;
  }


}
