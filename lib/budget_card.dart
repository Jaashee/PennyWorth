import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pennyworth/gsheets_api.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({Key? key}) : super(key: key);

  @override
  _BudgetCardState createState() => _BudgetCardState();
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
    _monthlyBudget = prefs.getDouble('monthlyBudget') ?? 0.0;

    if (GoogleSheetsApi.loading) {
      await GoogleSheetsApi.loadTransactions();
    }

    _currentSpent = GoogleSheetsApi.transactions
        .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

    setState(() {}); // Refresh UI after data load
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color foregroundColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    Color successColor = theme.colorScheme.secondary;
    Color errorColor = theme.colorScheme.error;

    return Card(
      color: theme.cardColor, // Adapts to dark/light mode
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Budget',
              style: TextStyle(
                fontSize: 24,
                color: foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set Budget: \$${_monthlyBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                color: foregroundColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current Spent: \$${_currentSpent.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                color:
                    _currentSpent > _monthlyBudget ? errorColor : successColor,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => AnimatedContainer(
                    height: 8,
                    width: constraints.maxWidth *
                        (_currentSpent /
                            _monthlyBudget.clamp(0.01, double.infinity)),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: _currentSpent > _monthlyBudget
                          ? errorColor
                          : successColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            // Optionally add an info icon button or other interactive elements here
          ],
        ),
      ),
    );
  }
}
