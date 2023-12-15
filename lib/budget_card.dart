import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final String balance;

  BudgetCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4.0,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          child: Center(
            child: Column(
              children: [
                Text(
                  'B A L A N C E',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                SizedBox(height: 50),
                Text(balance,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 32,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
