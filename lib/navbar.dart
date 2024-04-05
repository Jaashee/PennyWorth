// navbar.dart
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const NavBar({
    Key? key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    // Access the theme data from the context
    final theme = Theme.of(context);

    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.list, size: 30),
      const Icon(Icons.add, size: 30),
      const Icon(Icons.pie_chart, size: 30),
      const Icon(Icons.settings, size: 30),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: item,
          label: '',
        );
      }).toList(),
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemSelected,
      // Use theme colors for the bottom navigation bar
      backgroundColor:
          theme.bottomAppBarColor, // Adjusted for theme compatibility
      selectedItemColor:
          theme.colorScheme.secondary, // Highlight color for selected item
      unselectedItemColor:
          theme.unselectedWidgetColor, // Color for unselected items
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
