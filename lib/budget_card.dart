import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      _monthlyBudget = budget;
      // Here you would calculate the current spent based on transactions
      _currentSpent = 0.0; // Replace with actual calculation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 50, 50, 50), // Assuming a dark theme
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Set Budget: \$${_monthlyBudget.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Current Spent: \$${_currentSpent.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: _currentSpent / (_monthlyBudget > 0 ? _monthlyBudget : 1),
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}
