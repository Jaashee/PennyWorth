import 'package:flutter/material.dart';
import 'package:pennyworth/gsheets_api.dart';

import 'navbar.dart'; // Make sure this is correctly imported

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<void> _loadTransactionsFuture;

  @override
  void initState() {
    super.initState();
    // Start loading the transactions when the page is initialized
    _loadTransactionsFuture = GoogleSheetsApi.loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 1),
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<void>(
        future: _loadTransactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: GoogleSheetsApi.currentTrans.length,
              itemBuilder: (context, index) {
                final transaction = GoogleSheetsApi.currentTrans[index];
                return TransactionCard(
                  transName: transaction[
                      0], // Assuming first element is the transaction name
                  amount:
                      transaction[1], // Assuming second element is the amount
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transName;
  final String amount;

  const TransactionCard({
    Key? key,
    required this.transName,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Color.fromARGB(255, 50, 50, 50),
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.attach_money_rounded, size: 35),
              Text(transName,
                  style: TextStyle(fontSize: 22, color: Colors.white)),
              Text('-\$' + amount,
                  style: TextStyle(color: Colors.red, fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
