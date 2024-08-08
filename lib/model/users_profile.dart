class UserProfile {
  final String uid;
  final String name;
  final String pfpURL;
  final String role;  // Assuming you have a role field

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
    required this.role,
  });

  // Convert a UserProfile instance into a Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'pfpURL': pfpURL,
      'role': role,
    };
  }

  // Convert a Map into a UserProfile instance
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      name: json['name'],
      pfpURL: json['pfpURL'],
      role: json['role'],
    );
  }
}
