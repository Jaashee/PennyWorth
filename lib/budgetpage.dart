import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _budgetController = TextEditingController();

  Future<void> _saveBudget() async {
    final prefs = await SharedPreferences.getInstance();
    if (_budgetController.text.isNotEmpty) {
      final budget = double.tryParse(_budgetController.text);
      if (budget != null) {
        await prefs.setDouble('monthlyBudget', budget);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Monthly budget set to \$${budget.toStringAsFixed(2)}')),
        );
      }
    }
  }

  Future<void> _resetBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('monthlyBudget');
    _budgetController.clear();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget has been reset')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Monthly Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Budget',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _budgetController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter your budget',
                filled: true,
                fillColor: const Color.fromARGB(255, 92, 92, 92),
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, primary:
                        const Color.fromARGB(255, 92, 92, 92), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _saveBudget,
                  child: const Text('Set Budget'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Red color for the reset action
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _resetBudget,
                  child: const Text('Reset Budget'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
