import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _saveUserName(value);
                // Use a snackbar to show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Name updated successfully!'),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _saveUserName(_nameController.text);
                // Use a snackbar to show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Name updated successfully!'),
                  ),
                );
              },
              child: Text('Save Name'),
            ),
            // ...add other settings options here
          ],
        ),
      ),
    );
  }
}
