import 'package:flutter/material.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'navbar.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<void> _loadTransactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactionsFuture = GoogleSheetsApi.loadTransactions();
  }

  void _deleteTransaction(int index) async {
    await GoogleSheetsApi.deleteTransaction(
        index); // Implement this method in your API class.
    setState(() {
      GoogleSheetsApi.currentTrans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 1),
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: FutureBuilder<void>(
        future: _loadTransactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: GoogleSheetsApi.currentTrans.length,
              itemBuilder: (context, index) {
                final transaction = GoogleSheetsApi.currentTrans[index];
                return TransactionCard(
                  transName: transaction[0], // Transaction name
                  amount: transaction[1], // Transaction amount
                  onDelete: () => _deleteTransaction(index),
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
  final VoidCallback onDelete;

  const TransactionCard({
    Key? key,
    required this.transName,
    required this.amount,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(transName,
            style: const TextStyle(fontSize: 22, color: Colors.white)),
        trailing: Text('-\$' + amount,
            style: const TextStyle(color: Colors.red, fontSize: 22)),
        leading: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
