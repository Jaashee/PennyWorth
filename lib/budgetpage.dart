// budget_page.dart
import 'package:flutter/material.dart';
import 'package:pennyworth/gsheets_api.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String monthlyBalance = '';
  String totalExpenses = '';
  String remainingBudget = '';

  final _textMthAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            color: const Color.fromARGB(255, 50, 50, 50),
            elevation: 4.0,
            margin: EdgeInsets.only(top: 80, left: 8, right: 8, bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 225,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'M O N T H L Y  B U D G E T',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: Text(
                          '\$' + monthlyBalance,
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total Expenses: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                      Text(
                        'Budget Remaining: ',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromARGB(255, 50, 50, 50),
            elevation: 4.0,
            margin: EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                height: 150,
                child: Column(
                  children: [
                    Text(
                      'Set Monthly Budget',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Amount?',
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Enter an Amount';
                            }
                            return null;
                          },
                          controller: _textMthAmount,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        color: const Color.fromARGB(255, 50, 50, 50),
                        child: monthlyBalance == ''
                            ? Text('Set Amount')
                            : Text('Update Amount'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            monthlyBalance = _textMthAmount.text;
                            _textMthAmount.text = '';
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
