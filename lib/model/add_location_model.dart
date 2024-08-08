class Location {
  String name;
  Location({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
