import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final String balance;

  const BudgetCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 50, 50, 50),
      elevation: 4.0,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              children: [
                Text(
                  'B A L A N C E',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 50),
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
