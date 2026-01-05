import 'dart:io';

import 'package:flutter/material.dart';

import '../models/pet.dart';
import 'add_edit_pet_screen.dart';
import '../data/pet_repository.dart';
import '../data/reminder_repository.dart';
import '../models/reminder.dart';
import 'add_reminder_screen.dart';



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
            Navigator.pop(context); // Refresh list
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDelete(context),
        ),
        IconButton(
          icon: const Icon(Icons.alarm_add),
          onPressed: () async {
            final added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddReminderScreen(petId: pet.id),
              ),
            );

            if (added == true) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
      body: ListView(
        children: [
          _buildImage(),
          const SizedBox(height: 24),
          _buildInfoCard(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Reminders',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          FutureBuilder<List<Reminder>>(
            future: ReminderRepository.getRemindersForPet(pet.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No reminders added'),
                );
              }

              final reminders = snapshot.data!;

              return Column(
                children: reminders.map((r) {
                  return ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(r.title),
                    subtitle: Text(
                      '${r.type} • ${r.date.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ReminderRepository.deleteReminder(r.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pet'),
        content: const Text(
          'Are you sure you want to delete this pet? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await PetRepository.deletePet(pet.id);

              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close profile screen
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
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
