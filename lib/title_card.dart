import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TitleCard extends StatefulWidget {
  const TitleCard({Key? key}) : super(key: key);

  @override
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
    // Using Theme to adapt to dark/light mode
    var cardColor = Theme.of(context).cardColor;
    var textColor =
        Theme.of(context).textTheme.titleLarge?.color ?? Colors.white;
    var textStyle = TextStyle(color: textColor, fontSize: 16);

    return Card(
      color: cardColor,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 48, color: textColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pennyworth',
                  style: textStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Welcome, $_userName', style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
