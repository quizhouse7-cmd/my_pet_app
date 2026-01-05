import 'package:flutter/material.dart';
import 'screens/pet_list_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
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
