import 'package:flutter/material.dart';

void main() => runApp(PennyWorthApp());

class PennyWorthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyWorth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PennyWorth Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to PennyWorth!'),
      ),
    );
  }
}
