class Reminder {
  String id;
  String petId;
  String title;
  DateTime date;
  String type; // vaccination, vet, grooming

  Reminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      petId: map['petId'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}
