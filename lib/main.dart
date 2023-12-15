import 'package:flutter/material.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleSheetsApi().init();
  runApp(const PennyworthApp());
}

class PennyworthApp extends StatelessWidget {
  const PennyworthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pennyworth',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
