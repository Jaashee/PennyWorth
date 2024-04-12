import 'dart:io';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class GoogleSheetsApi {
  //Create credtials for gsheet api
  static const _credentials = r'''

''';

// spreadsheet id
  static const _spreadsheetId = '1MB0Y8gnErQF4hKs4-COXrgFs7OeoaSExeKXHyhK9sNA';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _transactionWorksheet;
  static Worksheet? _categoryWorksheet;

  // Add a list to keep categories
  static List<Category> categories = [];

  // Add a list to keep transactions
  static List<Transaction> transactions = [];

  //varibles for loading
  static bool loading = true;

  // Initialize Google Sheets
  Future<void> init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _transactionWorksheet = ss.worksheetByTitle('Transactions');
    _categoryWorksheet = ss.worksheetByTitle('Categories');
    await loadCategories(); // Fetch categories upon initialization
    await loadTransactions(); // Transaction rows
  }

// A method to export data to CSV
  static Future<String> exportTransactions() async {
    if (_transactionWorksheet == null) {
      return 'Worksheet not initialized';
    }

    final transactionsData = await _transactionWorksheet!.values.map.allRows();
    if (transactionsData == null) {
      return 'No data to export';
    }

    // A method to convert Excel date serial numbers to DateTime
    DateTime excelDateToDateTime(double excelDate) {
      // The Excel epoch starts on January 1, 1900
      return DateTime(1899, 12, 30).add(Duration(days: excelDate.toInt()));
    }

    // Get today's date to include in the file name
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final StringBuffer csvData = StringBuffer();
    for (var transaction in transactionsData) {
      final double excelDate = double.tryParse(transaction['Date']!) ?? 0;
      final formattedDate = excelDateToDateTime(excelDate);
      final dateString = DateFormat('yyyy-MM-dd').format(formattedDate);

      csvData.writeln(
          '${transaction['Id']},${transaction['Name']},${transaction['Amount']},$dateString,${transaction['Category']}');
    }

    // Define the filename with today's date
    final String fileName = 'transactions_$todayDate.csv';

    // Get the downloads directory
    final directory = (await getDownloadsDirectory()) ??
        (await getExternalStorageDirectory());
    final path = directory!.path;
    final file = File('$path/$fileName');

    // Write the file
    await file.writeAsString(csvData.toString());

    return 'Data exported successfully to $path/$fileName';
  }

// Load transactions from Google Sheets
  static Future<void> loadTransactions() async {
    if (_transactionWorksheet == null) return;

    transactions
        .clear(); // Clear the list before adding to it to avoid duplicates

    final transactionsData = await _transactionWorksheet!.values.map.allRows();
    if (transactionsData != null) {
      for (var transactionRow in transactionsData) {
        final id = transactionRow['Id'] ?? const Uuid().v1();
        final name = transactionRow['Name'] ?? 'No Name';
        final amount = double.tryParse(transactionRow['Amount'] ?? '0') ?? 0.0;
        final date = transactionRow['Date'] ??
            ''; // Ensure Date column exists in your sheet
        final category = transactionRow['Category'] ?? 'No Category';

        transactions.add(Transaction(
          id: id,
          name: name,
          amount: amount,
          date: date,
          category: category,
        ));
      }
    }

    loading = false;
  }

// Insert a new transaction into Google Sheets
  static Future<void> insert(Transaction transaction) async {
    if (_transactionWorksheet == null) return;

    final id = const Uuid().v1();
    await _transactionWorksheet!.values.appendRow([
      id,
      transaction.name,
      transaction.amount.toString(),
      transaction.date,
      transaction.category,
    ]);

    transactions.add(transaction.copyWith(id: id));
  }

// Update a transaction in Google Sheets
  static Future<void> updateTransaction(Transaction transaction) async {
    if (_transactionWorksheet == null || transaction.id.isEmpty) return;

    // Find the row number for the transaction to update
    final rowIndex = transactions.indexWhere((t) => t.id == transaction.id) +
        2; // +2 for headers and 1-based index
    await _transactionWorksheet!.values.insertRow(rowIndex, [
      transaction.id,
      transaction.name,
      transaction.amount.toString(),
      transaction.category,
    ]);
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction; // Update local list
    }
  }

// Delete a transaction from Google Sheets
  static Future<void> deleteTransaction(String transactionId) async {
    if (_transactionWorksheet == null) return;

    final rowIndex = transactions.indexWhere((t) => t.id == transactionId) +
        2; // +2 for headers and 1-based index
    if (rowIndex > 1) {
      // Ensures we don't delete headers
      await _transactionWorksheet!.deleteRow(rowIndex);
      transactions
          .removeWhere((t) => t.id == transactionId); // Update local list
    }
  }

  static Future<void> loadCategories() async {
    if (_categoryWorksheet == null) {
      // Initialize the worksheet or handle the error
      return;
    }

    categories.clear(); // Clear existing categories

    // Fetch the categories from the worksheet
    final categoriesData = await _categoryWorksheet!.values.map.allRows();
    if (categoriesData != null) {
      for (var categoryRow in categoriesData) {
        final id = categoryRow['Id'] ??
            const Uuid().v1(); // Ensuring an ID is always present
        final name = categoryRow['Name'] ?? 'Unnamed Category';
        final icon = categoryRow['Icon'] ?? ''; // Default icon if not specified
        final color =
            categoryRow['Color'] ?? '#FFFFFF'; // Default color if not specified

        // Create a new category and add it to the list
        categories.add(Category(id: id, name: name, icon: icon, color: color));
      }
    }

    loading = false; // Indicate that categories have finished loading
  }

  // Add a new category to Google Sheets
  static Future<void> addCategory(Category category) async {
    if (_categoryWorksheet == null) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
    await _categoryWorksheet!.values.appendRow([
      id,
      category.name,
      category.icon,
      category.color,
    ]);
    categories.add(category.copyWith(id: id)); // Update local list
  }

  // Update a category in Google Sheets
  static Future<void> updateCategory(Category category) async {
    if (_categoryWorksheet == null || category.id.isEmpty) return;

    // Find the row number for the category to update
    final rowIndex = categories.indexWhere((c) => c.id == category.id) +
        2; // +2 for headers and 1-based index
    await _categoryWorksheet!.values.insertRow(rowIndex, [
      category.id,
      category.name,
      category.icon,
      category.color,
    ]);
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category; // Update local list
    }
  }
}

class Transaction {
  String id;
  String name;
  double amount;
  String date; // Date should be a string
  String category;

  Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.date, // Add the date parameter
    required this.category,
  });

  Transaction.empty()
      : id = '',
        name = '',
        amount = 0.0,
        category = '',
        date = '';

  // Copy method for immutability
  Transaction copyWith({
    String? id,
    String? name,
    double? amount,
    String? category,
    String? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}

// Define a Category class
class Category {
  final String id;
  final String name;
  final String icon; // Store the filename of the icon
  final String color; // Store the ARGB value as a string

  Category(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color});

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
