import 'package:flutter/material.dart';
import '../data/pet_repository.dart';
import '../models/pet.dart';
import 'add_edit_pet_screen.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pets = PetRepository.getPets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets 🐾'),
      ),
      body: pets.isEmpty
          ? const Center(child: Text('No pets added yet'))
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return ListTile(
                  title: Text(pet.name),
                  subtitle: Text('${pet.type}, ${pet.age} years'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      PetRepository.deletePet(pet.id);
                      _refresh();
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditPetScreen(pet: pet),
                      ),
                    );
                    _refresh();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditPetScreen()),
          );
          _refresh();
        },
      ),
    );
  }
}
