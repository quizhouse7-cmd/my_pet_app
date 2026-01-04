import '../db/database_helper.dart';
import '../models/reminder.dart';
import 'package:uuid/uuid.dart';

class ReminderRepository {
  static const _uuid = Uuid();

  static String generateId() => _uuid.v4();

  static Future<void> addReminder(Reminder reminder) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('reminders', reminder.toMap());
  }

  static Future<List<Reminder>> getRemindersForPet(String petId) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'reminders',
      where: 'petId = ?',
      whereArgs: [petId],
      orderBy: 'date ASC',
    );

    return result.map((e) => Reminder.fromMap(e)).toList();
  }

  static Future<void> deleteReminder(String id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
