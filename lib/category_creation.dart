import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pennyworth/gsheets_api.dart';

class CategoryCreationPage extends StatefulWidget {
  const CategoryCreationPage({Key? key}) : super(key: key);

  @override
  _CategoryCreationPageState createState() => _CategoryCreationPageState();
}

class _CategoryCreationPageState extends State<CategoryCreationPage> {
  final _textControllerName = TextEditingController();
  Color currentColor = Colors.blue;

  void _saveCategory() async {
    final String categoryName = _textControllerName.text.trim();
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a category name'),
      ));
      return;
    }

    // Convert the Color to a hex string.
    String colorString =
        '#${currentColor.value.toRadixString(16).padLeft(8, '0').substring(2)}';

    // Create a new category object
    final Category newCategory = Category(
      id: '', // Temporary empty string, will be set by GoogleSheetsApi.addCategory
      name: categoryName,
      icon: '', // TODO: Assign icon based on your icon picker result
      color: colorString,
    );

    // Save the new category using the API
    await GoogleSheetsApi.addCategory(newCategory);

    Navigator.of(context).pop(); // Pop the current page if successful
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textControllerName,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            // Icon picker would go here
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open color picker dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentColor,
                          onColorChanged: (color) =>
                              setState(() => currentColor = color),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Done'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Pick a Color'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              child: const Text('Save Category'),
            ),
          ],
        ),
      ),
    );
  }
}
