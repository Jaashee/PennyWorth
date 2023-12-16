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
        scaffoldBackgroundColor: const Color.fromARGB(255, 200, 200, 200),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 50, 50, 50),
          onPrimary: Colors.white,
          secondary: Colors.blueGrey,
          surface:
              Color.fromARGB(255, 50, 50, 50), // Used for card background color
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyLarge: const TextStyle(color: Colors.white),
              bodyMedium:
                  const TextStyle(color: Color.fromARGB(179, 255, 255, 255)),
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
