import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // Placeholder for transactions list, start with an empty list
  List<Map<String, dynamic>> transactions = [];

  // Function to add a new transaction
  void addTransaction(Map<String, dynamic> newTransaction) {
    setState(() {
      transactions.add(newTransaction);
    });
    // Here you would also update the Google Sheets data
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pennyworth'),
        backgroundColor: Colors.black, // Set your dark theme color here
      ),
      body: Column(
        children: <Widget>[
          // Balance Card
          // Placeholder for balance, start with zero
          Card(
            color: Colors.grey[900],
            elevation: 4.0,
            margin: EdgeInsets.all(8.0),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'BALANCE',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  // Placeholder for dynamic balance
                  Text(
                    '\$0', // This will be fetched from Google Sheets
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Transactions List
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'No transactions yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var transaction = transactions[index];
                      // Replace with your transaction item UI
                      return ListTile(
                        leading: const Icon(Icons.account_balance_wallet,
                            color: Colors.white),
                        title: Text(
                          transaction['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          transaction['details'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          '-\$${transaction['amount']}',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black, // Set your dark theme color here
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
