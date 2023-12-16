import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'homepage.dart'; // Import your page widgets
import 'transactionspage.dart';
import 'add_expensepage.dart';
import 'budgetpage.dart';
import 'settingspage.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;

  const NavBar({
    Key? key,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex; // Will be initialized in initState

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.selectedIndex; // Use the initial index provided by the widget
  }

  // List of page widgets to navigate to
  final List<Widget> _pages = [
    const HomePage(), // index 0
    TransactionsPage(), // index 1
    const AddExpensePage(), // index 2
    BudgetPage(), // index 3
    const SettingsPage(), // index 4
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
