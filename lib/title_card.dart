import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TitleCard extends StatefulWidget {
  const TitleCard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TitleCardState createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'User';
    setState(() {
      _userName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 50, 50, 50),
      elevation: 4.0,
      margin: const EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 70,
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Text(
                  'P E N N Y W O R T H',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text('Welcome, $_userName', // Use the loaded user name
                    style: TextStyle(color: Colors.grey[500], fontSize: 16))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
