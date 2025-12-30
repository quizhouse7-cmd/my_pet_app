import 'dart:math';
import '../db/database_helper.dart';
import '../models/pet.dart';

class PetRepository {
  static Future<List<Pet>> getPets() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('pets');
    return result.map((e) => Pet.fromMap(e)).toList();
  }

  static Future<void> addPet(Pet pet) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('pets', pet.toMap());
  }

  static Future<void> updatePet(Pet pet) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  static Future<void> deletePet(String id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static String generateId() {
    return Random().nextInt(100000).toString();
  }
}
