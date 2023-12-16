import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final Color _darkGrey = const Color.fromARGB(255, 50, 50, 50); // Navbar color

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('userName') ?? '';
  }

  Future<void> _saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      // To show quick pop-up message
      const SnackBar(content: Text('Name updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 4),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: _darkGrey,
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
                primary: _darkGrey, // Button color
                onPrimary: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _saveUserName(_nameController.text);
              },
              child: const Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
