import 'package:flutter/material.dart';
import 'package:pennyworth/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gsheets_api.dart';
import 'theme_mode_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  // Initialize Google Sheets API before the app starts.
  await GoogleSheetsApi().init();

  runApp(
    ChangeNotifierProvider<ThemeModeNotifier>(
      create: (context) =>
          ThemeModeNotifier(isDarkMode ? ThemeMode.dark : ThemeMode.light),
      child: const MyApp(),
    ),
  );
}



// Light Theme
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber, // A swatch that doesn't strain the eyes
  hintColor: Colors.amber[200],
  colorScheme: const ColorScheme.light(
    secondary: Colors.grey,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
    labelLarge: TextStyle(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.grey[300]),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    buttonColor: Colors.grey[300],
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[100],
    iconTheme: IconThemeData(color: Colors.grey[500]),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    // This will be the background color of the progress bar
    color: Colors.grey.withOpacity(0.3),
  ),
  
  // ... other customizations
);

// Dark Theme
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber,
  hintColor: Colors.amberAccent.shade100,
  colorScheme: const ColorScheme.dark(
    // ... other colors
    secondary:
        Colors.orange, // This color will be used for the progress bar fill
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.amber),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.amber[100]),
    labelLarge: const TextStyle(color: Colors.black),
  ),
  iconTheme: IconThemeData(color: Colors.amberAccent[200]),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    buttonColor: Colors.amber,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    fillColor: Colors.amber[700],
    filled: true,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.amber[800],
    iconTheme: IconThemeData(color: Colors.amberAccent[200]),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    // This will be the background color of the progress bar
    color: Colors.grey.withOpacity(0.3),
  ),
  // ... other customizations
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Pennyworth',
          theme: _lightTheme, // Define your light theme here
          darkTheme: _darkTheme, // Define your dark theme here
          themeMode:
              themeNotifier.themeMode, // Use the themeMode from the provider
          home: const MainScreen(),
        );
      },
    );
  }
}
