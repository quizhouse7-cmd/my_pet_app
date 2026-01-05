import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data/reminder_repository.dart';
import '../models/reminder.dart';
import '../services/notification_service.dart';


class AddReminderScreen extends StatefulWidget {
  final String petId;

  const AddReminderScreen({super.key, required this.petId});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();

  DateTime? _selectedDate;
  String _type = 'Vaccination';

  final _types = ['Vaccination', 'Vet Visit', 'Grooming'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    final reminder = Reminder(
      id: const Uuid().v4(),
      petId: widget.petId,
      title: _titleCtrl.text,
      date: _selectedDate!,
      type: _type,
    );

    await ReminderRepository.addReminder(reminder);

    try {
      await NotificationService.scheduleNotification(
        id: reminder.id.hashCode,
        title: 'Pet Reminder',
        body: '${reminder.title} for your pet',
        scheduledDate: reminder.date,
      );
      print('Notification scheduled');
    } catch (e) {
      print('Notification error: $e');
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration:
                    const InputDecoration(labelText: 'Reminder title'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                items: _types
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
                decoration:
                    const InputDecoration(labelText: 'Reminder type'),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _selectedDate == null
                      ? 'Select date'
                      : _selectedDate!
                          .toLocal()
                          .toString()
                          .split(' ')[0],
                ),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveReminder,
                  child: const Text('Save Reminder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
