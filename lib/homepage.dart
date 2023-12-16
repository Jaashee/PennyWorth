import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pennyworth/budget_card.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'package:pennyworth/loading_circle.dart';
import 'package:pennyworth/navbar.dart';
import 'package:pennyworth/title_card.dart';
import 'package:pennyworth/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        // Wrap your layout with SafeArea
        child: Column(
          children: [
            const TitleCard(),
            BudgetCard(
              balance: '\$ 10000',
            ),
            Expanded(
              child: GoogleSheetsApi.loading == true
                  ? const LoadingCircle()
                  : ListView.builder(
                      itemCount: GoogleSheetsApi.currentTrans.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(
                          transName: GoogleSheetsApi.currentTrans[index][0],
                          amount: GoogleSheetsApi.currentTrans[index][1],
                        );
                      },
                    ),
            ),
          ],
        ),
      ), // Your custom bottom navigation bar
    );
  }
}

// int _selectedIndex = 0;
// // Placeholder for transactions list, start with an empty list
// List<Map<String, dynamic>> transactions = [];

// // Function to add a new transaction
// void addTransaction(Map<String, dynamic> newTransaction) {
//   setState(() {
//     transactions.add(newTransaction);
//   });
//   // Here you would also update the Google Sheets data
// }

// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }
