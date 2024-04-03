import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pennyworth/theme_mode_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isDarkMode = false; // default value

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadThemePreference(); // Load the theme preference
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('userName') ?? '';
  }

  Future<void> _saveUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name updated successfully!')),
    );
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool isOn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
    Provider.of<ThemeModeNotifier>(context, listen: false).themeMode =
        isOn ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // If you want to use the navbar color here as well, create a color variable accessible from both widgets.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // Changed to ListView to avoid overflow when keyboard appears
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: const Color.fromARGB(255, 50, 50,
                    50), // Replaced _darkGrey with actual Color value
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: const TextStyle(color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 50, 50, 50), // Button color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed:
                  _saveUserName, // Removed the parameter from function call
              child: const Text('Save Name'),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
              activeColor: Colors.blue, // or any other color you prefer
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.white30,
            ),
          ],
        ),
      ),
    );
  }
}
