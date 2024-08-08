import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtoktask/service/firestore_service.dart';

class LocationListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations')),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: FirestoreService().getAllLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No locations found.'));
          } else {
            var locations = snapshot.data!;
            return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                var location = locations[index];
                return Card(
                  child: ListTile(
                    title: Text(
                        '${location['city']}, ${location['district']}, ${location['state']}, ${location['country']}'),
                    subtitle: Text(
                        'Country: ${location['country']}\nState: ${location['state']}\nDistrict: ${location['district']}\nCity: ${location['city']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
