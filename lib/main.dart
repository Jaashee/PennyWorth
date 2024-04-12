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

// Define common styles and colors
const Color _lightPrimaryColor = Color(0xFFE7E7E8);
const Color _darkPrimaryColor = Color(0xFF18191A);
const Color _accentColor = Color(0xFF007FFF); // A modern blue accent color

// Reusable text theme
TextTheme _buildTextTheme(TextTheme base, Color textColor) {
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 16.0, color: textColor),
    labelLarge: base.labelLarge?.copyWith(color: textColor),
  );
}

// Light Theme
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: _lightPrimaryColor,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: _lightPrimaryColor,
    secondary: _accentColor,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
  ),
  textTheme: _buildTextTheme(ThemeData.light().textTheme, Colors.black),
  iconTheme: const IconThemeData(color: _accentColor),
  appBarTheme: const AppBarTheme(
    color: _lightPrimaryColor,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: _accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    buttonColor: _accentColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _accentColor)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _accentColor,
    ),
  ),
);

// Dark Theme
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: _darkPrimaryColor,
  scaffoldBackgroundColor: const Color(0xFF242526),
  colorScheme: const ColorScheme.dark(
    primary: _darkPrimaryColor,
    secondary: _accentColor,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
  textTheme: _buildTextTheme(ThemeData.dark().textTheme, Colors.white),
  iconTheme: const IconThemeData(color: _accentColor),
  appBarTheme: const AppBarTheme(
    color: _darkPrimaryColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: _accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    buttonColor: _accentColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _accentColor)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _accentColor,
    ),
  ),
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
