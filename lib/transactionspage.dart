import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pennyworth/gsheets_api.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
  void reloadData() {}
}

class _TransactionsPageState extends State<TransactionsPage> {
  int? selectedYear;
  int? selectedMonth;
  List<Transaction> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
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

  DateTime excelDateToDateTime(double excelDate) {
    return DateTime(1899, 12, 30).add(Duration(days: excelDate.toInt()));
  }

  void filterTransactions() {
    filteredTransactions = GoogleSheetsApi.transactions.where((transaction) {
      try {
        final excelDate = double.tryParse(transaction.date);
        if (excelDate != null) {
          DateTime transactionDate = excelDateToDateTime(excelDate);
          return transactionDate.year == selectedYear &&
              transactionDate.month == selectedMonth;
        } else {
          print('Error parsing date: ${transaction.date}');
        }
      } catch (e) {
        print('Error parsing date: ${transaction.date}, Error: $e');
      }
      return false; // If parsing fails, exclude this transaction
    }).toList();
    setState(() {}); // Refresh the UI with the filtered list
  }

  void onYearChanged(int? year) {
    setState(() {
      selectedYear = year;
      filterTransactions();
    });
  }

  void onMonthChanged(int? month) {
    setState(() {
      selectedMonth = month;
      filterTransactions();
    });
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

  void showYearPicker() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Year'),
          children: List<Widget>.generate(10, (int index) {
            int year = DateTime.now().year - index;
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, year);
              },
              child: Text(year.toString()),
            );
          }),
        );
      },
    ).then((int? selectedYear) {
      if (selectedYear != null) {
        onYearChanged(selectedYear);
      }
    });
  }

  void showMonthPicker() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Month'),
          children: List<Widget>.generate(12, (int index) {
            int month = index + 1;
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, month);
              },
              child: Text(DateFormat('MMMM').format(DateTime(0, month))),
            );
          }),
        );
      },
    ).then((int? selectedMonth) {
      if (selectedMonth != null) {
        onMonthChanged(selectedMonth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Transactions - Select Year and Month'),
        actions: const <Widget>[],
      ),
      body: Column(
        children: [
          // New date selection UI at the top of the transactions list
          Container(
            color: Theme.of(context).primaryColor, // Match the theme
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton.icon(
                  // Year Button
                  icon: const Icon(Icons.calendar_today),
                  label: Text('Year: $selectedYear'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: showYearPicker,
                ),
                TextButton.icon(
                  // Month Button
                  icon: const Icon(Icons.calendar_view_month),
                  label: Text('Month: $selectedMonth'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: showMonthPicker,
                ),
              ],
            ),
          ),
          Expanded(
            // Wrap your ListView.builder in an Expanded widget
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                DateTime parsedDate;
                try {
                  final excelDate = double.tryParse(transaction.date);
                  if (excelDate != null) {
                    parsedDate = excelDateToDateTime(excelDate);
                  } else {
                    throw const FormatException(
                        'The date is not in an Excel serial number format.');
                  }
                } catch (e) {
                  print('Error parsing date: ${transaction.date}, Error: $e');
                  parsedDate = DateTime.now(); // Fallback to current date
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
          ),
        ],
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
    'Subscription': FontAwesomeIcons.repeat,
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
    'Subscription': Colors.cyan,
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
