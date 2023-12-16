// add_expense_page.dart
import 'package:flutter/material.dart';
import 'package:pennyworth/gsheets_api.dart';

import 'navbar.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textControllerItem.text,
      _textControllerAmount.text,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 2),
      body: Column(
        children: [
          Card(
            color: const Color.fromARGB(255, 50, 50, 50),
            elevation: 4.0,
            margin:
                const EdgeInsets.only(top: 80, left: 8, right: 8, bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'A D D  E X P E N S E',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an Amount';
                                  }
                                  return null;
                                },
                                controller: _textControllerAmount,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'What is the Expense for?',
                              ),
                              controller: _textControllerItem,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
              color: const Color.fromARGB(255, 50, 50, 50),
              child: const Text(
                'Add Expense',
                style: TextStyle(),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _enterTransaction();
                  _textControllerAmount.text = '';
                  _textControllerItem.text = '';
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sucessful!'),
                          content: const Text('Expense has been added'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
