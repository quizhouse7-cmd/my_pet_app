import '../models/pet.dart';
import 'dart:math';

class PetRepository {
  static final List<Pet> _pets = [];

  static List<Pet> getPets() => _pets;

  static void addPet(Pet pet) {
    _pets.add(pet);
  }

  static void updatePet(Pet pet) {
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
    }
  }

  static void deletePet(String id) {
    _pets.removeWhere((p) => p.id == id);
  }

  static String generateId() {
    return Random().nextInt(100000).toString();
  }
}
