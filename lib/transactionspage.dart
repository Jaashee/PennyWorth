import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pennyworth/gsheets_api.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
  void reloadData() {}
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    // Ensure categories are loaded first, as they may be needed for transactions.
    await GoogleSheetsApi.loadCategories();
    // Then load transactions.
    await GoogleSheetsApi.loadTransactions();
    if (mounted) {
      setState(() {
        // This will trigger a rebuild of your TransactionsPage with the updated transactions.
      });
    }
  }

  // This method can be called from outside to reload transactions
  void reloadData() {
    loadTransactions();
  }

  void _deleteTransaction(String transactionId) async {
    await GoogleSheetsApi.deleteTransaction(transactionId);
    setState(() {
      // Update the UI after deleting the transaction
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: GoogleSheetsApi.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: GoogleSheetsApi.transactions.length,
              itemBuilder: (context, index) {
                final transaction = GoogleSheetsApi.transactions[index];
                DateTime parsedDate;
                try {
                  parsedDate = DateFormat('YYYY-MM-DD').parse(transaction.date);
                } on FormatException {
                  // Handle the case where the date format isn't correct or is null
                  parsedDate = DateTime
                      .now(); // Fallback to current date or some default
                }
                return TransactionCard(
                  transName: transaction.name,
                  amount: transaction.amount.toString(),
                  date: parsedDate, // Now passing a DateTime object
                  category: transaction.category,
                  onDelete: () => _deleteTransaction(transaction.id),
                );
              },
            ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transName;
  final String amount;
  final DateTime date;
  final String category;
  final VoidCallback onDelete;

  // Define your category icons and colors here
  static const Map<String, IconData> categoryIcons = {
    'Food & Dining': FontAwesomeIcons.utensils,
    'Utilities': FontAwesomeIcons.lightbulb,
    'Housing': FontAwesomeIcons.house,
    'Transportation': FontAwesomeIcons.bus,
    'Shopping': FontAwesomeIcons.cartShopping,
    'Entertainment': FontAwesomeIcons.film,
    'Travel': FontAwesomeIcons.plane,
    'Education': FontAwesomeIcons.graduationCap,
    'Personal Care': FontAwesomeIcons.handSparkles,
    'Health & Wellness': FontAwesomeIcons.heartPulse,
    'Savings & Investments': FontAwesomeIcons.piggyBank,
    'Kids': FontAwesomeIcons.baby,
    'Pets': FontAwesomeIcons.paw,
    'Gifts & Donations': FontAwesomeIcons.gift,
    'Miscellaneous': FontAwesomeIcons.ellipsis,
    // Add more categories and corresponding icons here
  };

  static const Map<String, Color> categoryColors = {
    'Food & Dining': Colors.orange,
    'Utilities': Colors.blue,
    'Housing': Colors.green,
    'Transportation': Colors.purple,
    'Shopping': Colors.red,
    'Entertainment': Colors.pink,
    'Travel': Colors.teal,
    'Education': Colors.indigo,
    'Personal Care': Colors.amber,
    'Health & Wellness': Colors.lightGreen,
    'Savings & Investments': Colors.deepOrange,
    'Kids': Colors.lightBlue,
    'Pets': Colors.brown,
    'Gifts & Donations': Colors.pinkAccent,
    'Miscellaneous': Colors.grey,
    // Add more categories and corresponding colors here
  };

  const TransactionCard({
    Key? key,
    required this.transName,
    required this.amount,
    required this.date,
    required this.category,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = categoryIcons[category] ?? FontAwesomeIcons.circleQuestion;
    Color iconColor = categoryColors[category] ?? Colors.grey;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(transName),
        subtitle: Text(formattedDate),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '-\$ $amount',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              IconButton(
                icon: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.error),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
