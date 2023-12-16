// add_expense_page.dart
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        color: const Color.fromARGB(255, 50, 50, 50),
        elevation: 4.0,
        margin: EdgeInsets.only(top: 80, left: 8, right: 8, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'A D D  E X P E N S E',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          //key: _formKey,
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
                            controller: _textControllerAmount,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
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
    );
  }
}
