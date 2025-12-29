import 'package:flutter/material.dart';
import 'screens/pet_list_screen.dart';

void main() {
  runApp(const MyPetApp());
}

class MyPetApp extends StatelessWidget {
  const MyPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Pet App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PetListScreen(),
    );
  }
}
