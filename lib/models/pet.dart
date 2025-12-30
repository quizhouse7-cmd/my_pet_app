class Pet {
  String id;
  String name;
  String type;
  int age;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      age: map['age'],
    );
  }
}
