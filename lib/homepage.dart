import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'package:pennyworth/loading_circle.dart';
import 'package:pennyworth/title_card.dart';
import 'package:pennyworth/transaction_card.dart';
import 'budget_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Call the method to load transactions when the widget is initialized
    _loadData();
  }

  Future<void> _loadData() async {
    // Make sure categories are loaded before transactions because
    // transactions may depend on categories data
    await GoogleSheetsApi.loadCategories();
    await GoogleSheetsApi.loadTransactions();
    if (mounted) {
      setState(() {
        // This will rebuild the widget after loading is complete.
      });
    }
  }

  // Assuming you have a method to get the category details. Modify as needed.
  IconData getCategoryIcon(String category) {
    // Your logic to get the icon data based on the category
    // For now, let's return a dummy icon
    return FontAwesomeIcons.utensils; // Example icon
  }

  Color getCategoryColor(String category) {
    // Your logic to get the color based on the category
    // For now, let's return a dummy color
    return Colors.orange; // Example color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const TitleCard(),
            const BudgetCard(),
            // Use a FutureBuilder to wait for the transactions to load
            Expanded(
              child: GoogleSheetsApi.loading
                  ? const LoadingCircle()
                  : ListView.builder(
                      itemCount: GoogleSheetsApi.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = GoogleSheetsApi.transactions[index];

                        // You may need to add logic to fetch the category details
                        IconData icon = getCategoryIcon(transaction.category);
                        Color iconColor =
                            getCategoryColor(transaction.category);

                        return TransactionCard(
                            transName: transaction.name,
                            amount: transaction.amount.toString(),
                            categoryName: transaction.category,
                            categoryIcon: icon,
                            iconColor: iconColor,
                            onDelete: () {
                              // Your delete logic
                            },
                            description: '',
                            category: '');
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
