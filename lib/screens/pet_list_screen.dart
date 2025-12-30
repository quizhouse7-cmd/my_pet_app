import 'dart:io';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets 🐾'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: PetRepository.getPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No pets added yet'),
            );
          }

          final pets = snapshot.data!;

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];

              return ListTile(
                leading: pet.imagePath != null &&
                        File(pet.imagePath!).existsSync()
                    ? CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            FileImage(File(pet.imagePath!)),
                      )
                    : const CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.pets),
                      ),
                title: Text(pet.name),
                subtitle: Text('${pet.type}, ${pet.age} years'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await PetRepository.deletePet(pet.id);
                    setState(() {});
                  },
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditPetScreen(pet: pet),
                    ),
                  );
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditPetScreen(),
            ),
          );
          setState(() {});
        },
      ),
    );
  }
}
