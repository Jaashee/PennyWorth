import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'gsheets_api.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _subscriptionNameController =
      TextEditingController();
  final TextEditingController _subscriptionAmountController =
      TextEditingController();

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

  Future<void> _saveSubscription() async {
    String name = _subscriptionNameController.text;
    double? amount = double.tryParse(_subscriptionAmountController.text);

    if (name.isNotEmpty && amount != null) {
      // Create a new Transaction with the subscription details
      final newSubscription = Transaction(
        id: const Uuid().v1(), // Generate a new UUID for the transaction
        name: name,
        amount: amount,
        date: DateFormat('yyyy-MM-dd')
            .format(DateTime.now()), // Use the current date or a specified date
        category:
            'Subscription', // You can create a 'Subscription' category or use an existing one
      );

      // Use the GoogleSheetsApi to insert the new subscription
      await GoogleSheetsApi.insert(newSubscription).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription added successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add subscription: $error')),
        );
      });

      // Reset the form fields
      _subscriptionNameController.clear();
      _subscriptionAmountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Monthly Budget'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
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
                      foregroundColor: Colors.white,
                      primary:
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
              const Text(
                'Add Subscription',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _subscriptionNameController,
                decoration: InputDecoration(
                  hintText: 'Subscription Name',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 92, 92, 92),
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _subscriptionAmountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Monthly Amount',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 92, 92, 92),
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 92, 92, 92), // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveSubscription,
                child: const Text('Save Subscription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
