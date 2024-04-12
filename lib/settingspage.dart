import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pennyworth/theme_mode_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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

    // Notify listeners that the theme mode has changed.
    var themeNotifier = Provider.of<ThemeModeNotifier>(context, listen: false);
    themeNotifier.toggleTheme(isOn);

    // Rebuild the current page to reflect the theme change immediately.
    setState(() {
      _isDarkMode = isOn;
    });
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
                foregroundColor: Colors.white,
                backgroundColor:
                    const Color.fromARGB(255, 50, 50, 50), // Text color
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
            ElevatedButton(
              onPressed: () async {
                final result = await GoogleSheetsApi.exportTransactions();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
              },
              child: const Text('Export To CSV'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Define the path of the file.
                // This should be the absolute path of the file you want to open.

                // Use the `open_file` package to open the file.
                // The file manager may navigate to the file's location.
                final result = await OpenFilex.open(
                    "/storage/emulated/0/Android/data/com.example.pennyworth/files/downloads");

                // Optionally handle the result.
                print(result.message);
              },
              child: const Text('Open File Location'),
            ),
          ],
        ),
      ),
    );
  }
}
