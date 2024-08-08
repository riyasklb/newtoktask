class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  UserProfile({
    required this.uid,
    required this.name, this.pfpURL,
  });

  // Named constructor for JSON deserialization
  UserProfile.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        pfpURL = json['pfpURL'];

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Corrected map initialization
    data['uid'] = uid;
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    return data;
  }
}
