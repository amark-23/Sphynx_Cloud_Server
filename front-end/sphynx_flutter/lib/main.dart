import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SphynxApp());
}

class SphynxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sphynx File Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // The main home screen
    );
  }
}
