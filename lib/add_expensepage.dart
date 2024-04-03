// add_expense_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pennyworth/category_creation.dart';
import 'package:pennyworth/gsheets_api.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _textControllerDate = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _textControllerDate.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: GoogleSheetsApi.categories.length,
            itemBuilder: (context, index) {
              final category = GoogleSheetsApi.categories[index];
              final icon = _getIconData(
                  category.icon); // Function to map string to IconData
              return ListTile(
                leading: Icon(icon,
                    color: Color(
                        int.parse(category.color.replaceFirst('#', '0xff')))),
                title: Text(category.name,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                    Navigator.pop(context); // Close the modal bottom sheet
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

// This method maps the icon name from the sheet to the IconData object
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'fa-utensils':
        return FontAwesomeIcons.utensils;
      case 'fa-water':
        return FontAwesomeIcons.lightbulb;
      case 'fa-home':
        return FontAwesomeIcons.house;
      case 'fa-bus-alt':
        return FontAwesomeIcons.bus;
      case 'fa-shopping-cart':
        return FontAwesomeIcons.cartShopping;
      case 'fa-film':
        return FontAwesomeIcons.film;
      case 'fa-plane':
        return FontAwesomeIcons.plane;
      case 'fa-graduation-cap':
        return FontAwesomeIcons.graduationCap;
      case 'fa-cut':
        return FontAwesomeIcons.handSparkles;
      case 'fa-heartbeat':
        return FontAwesomeIcons.heartPulse;
      case 'fa-piggy-bank':
        return FontAwesomeIcons.piggyBank;
      case 'fa-baby':
        return FontAwesomeIcons.baby;
      case 'fa-paw':
        return FontAwesomeIcons.paw;
      case 'fa-gift':
        return FontAwesomeIcons.gift;
      case 'fa-ellipsis-h':
        return FontAwesomeIcons.ellipsis;
      default:
        return FontAwesomeIcons
            .circleQuestion; // A default icon in case the name doesn't match
    }
  }

  void _enterTransaction() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    final newTransaction = Transaction(
      id: const Uuid().v1(),
      name: _textControllerItem.text,
      amount: double.tryParse(_textControllerAmount.text) ?? 0.0,
      date: _textControllerDate.text,
      category: _selectedCategory!.name,
    );

    GoogleSheetsApi.insert(newTransaction).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );
      _resetForm();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense: $error')),
      );
    });
  }

  void _resetForm() {
    _textControllerAmount.clear();
    _textControllerItem.clear();
    _textControllerDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      _selectedCategory = null;
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _textControllerDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Or any dark color of your choice
        title:
            const Text('Add Expenses', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _textControllerAmount,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon:
                        const Icon(Icons.attach_money, color: Colors.white),
                    fillColor: Colors.grey[800],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _textControllerItem,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.grey[800],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: _selectedCategory != null
                      ? Text(
                          _selectedCategory!.name,
                          style: const TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Select Category',
                          style: TextStyle(color: Colors.grey),
                        ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      // This is where you handle the plus icon's onTap event
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                            builder: (context) => const CategoryCreationPage()),
                      )
                          .then((_) {
                        // Optionally refresh the category list if it's changed
                        // This would re-run build method of your StatefulWidget
                        setState(() {});
                      });
                    },
                  ),
                  tileColor: Colors.grey[800],
                  onTap: () => _showCategoryPicker(context),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal:
                          20), // Keep consistent padding with TextFormFields
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _textControllerDate,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    suffixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white),
                    fillColor: Colors.grey[800],
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _enterTransaction,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
