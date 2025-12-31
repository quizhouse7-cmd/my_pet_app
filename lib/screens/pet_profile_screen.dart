import 'dart:io';

import 'package:flutter/material.dart';

import '../models/pet.dart';
import 'add_edit_pet_screen.dart';

class PetProfileScreen extends StatelessWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditPetScreen(pet: pet),
                ),
              );
              Navigator.pop(context); // Refresh list after edit
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildImage(),
          const SizedBox(height: 24),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 280,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Hero(
        tag: 'pet_${pet.id}',
        child: pet.imagePath != null &&
                File(pet.imagePath!).existsSync()
            ? Image.file(
                File(pet.imagePath!),
                fit: BoxFit.cover,
                )
            : const Icon(
                Icons.pets,
                size: 120,
                color: Colors.grey,
                ),
        ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Name', pet.name),
              const Divider(),
              _infoRow('Type', pet.type),
              const Divider(),
              _infoRow('Age', '${pet.age} years'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
