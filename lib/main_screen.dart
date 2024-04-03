// main_screen.dart
import 'package:flutter/material.dart';
import 'gsheets_api.dart';
import 'navbar.dart';
import 'homepage.dart';
import 'transactionspage.dart';
import 'add_expensepage.dart';
import 'budgetpage.dart';
import 'settingspage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int page = _pageController.page!.round();
      if (_selectedIndex != page) {
        setState(() {
          _selectedIndex = page;
        });
        // You can refresh data for a specific page here if needed
        if (page == 1) {
          // This is just an illustrative example, you need to adjust it
          // depending on how your TransactionsPage is structured
          (_pages[1] as TransactionsPage).reloadData();
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadData() async {
    // Since GoogleSheetsApi.init() is called at the app start, it's assumed that
    // the initialization is complete here. Now, we can load other data.
    await GoogleSheetsApi.loadTransactions();
    await GoogleSheetsApi
        .loadCategories(); // Assuming you have a method to load categories.

    // If you need to do something with the data right after loading,
    // this is the place to do it.
  }

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionsPage(),
    const AddExpensePage(),
    const BudgetPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
