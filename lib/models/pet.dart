class Pet {
  String id;
  String name;
  String type;
  int age;
  String? imagePath; // Path to image file (camera / gallery)

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    this.imagePath,
  });

  /// Convert Pet object to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'imagePath': imagePath,
    };
  }

  /// Create Pet object from SQLite Map
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      age: map['age'],
      imagePath: map['imagePath'],
    );
  }
}
