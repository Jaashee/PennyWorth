import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'homepage.dart'; // Import your page widgets
import 'transactionspage.dart';
import 'add_expensepage.dart';
import 'budgetpage.dart';
import 'settingspage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Keep track of the selected index

  // List of page widgets to navigate to
  final List<Widget> _pages = [
    HomePage(), // index 0
    TransactionsPage(), // index 1
    AddExpensePage(), // index 2
    BudgetPage(), // index 3
    SettingsPage(), // index 4
  ];

  void _navigateTo(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.list, size: 30),
      const Icon(Icons.add, size: 30),
      const Icon(Icons.pie_chart, size: 30),
      const Icon(Icons.settings, size: 30),
    ];

    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.blueAccent,
      color: const Color.fromARGB(255, 50, 50, 50),
      height: 60,
      items: items,
      index: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _navigateTo(index); // Call the navigation function
      },
    );
  }
}
