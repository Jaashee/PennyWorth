import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 50, 50, 50),
      elevation: 4.0,
      margin: EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Text(
                  'P E N N Y W O R T H',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                SizedBox(height: 10),
                Text('Welcome, User',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
