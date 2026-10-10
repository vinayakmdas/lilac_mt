import 'package:flutter/material.dart';

/// Opens when the center "+" button is tapped.
class AddTransactionView extends StatelessWidget {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        backgroundColor: const Color(0xFF3F8780),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Transaction Page',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}