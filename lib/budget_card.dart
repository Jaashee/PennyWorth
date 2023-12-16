import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gsheets_api.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({Key? key}) : super(key: key);

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  double _monthlyBudget = 0.0;
  double _currentSpent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  Future<void> _loadBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    final budget = prefs.getDouble('monthlyBudget') ?? 0.0;

    // Fetch the transaction amounts
    final transactionAmounts = await GoogleSheetsApi.getTransactionAmounts();
    // Calculate the total spent by summing the negative amounts (expenses)
    final spent = transactionAmounts.fold(
        0.0, (sum, amount) => sum + (amount < 0 ? amount : 0));

    setState(() {
      _monthlyBudget = budget;
      _currentSpent = spent.abs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Assuming a dark theme
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Budget',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Set Budget: \$${_monthlyBudget.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current Spent: \$${_currentSpent.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _currentSpent / (_monthlyBudget > 0 ? _monthlyBudget : 1),
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}
