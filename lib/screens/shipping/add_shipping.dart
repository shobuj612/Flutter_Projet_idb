import 'package:flutter/material.dart';

class AddShippingScreen extends StatefulWidget {
  const AddShippingScreen({super.key});

  @override
  State<AddShippingScreen> createState() => _AddShippingScreenState();
}

class _AddShippingScreenState extends State<AddShippingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shipping')),
      body: const Center(
        child: Text('Shipping form will appear here'),
      ),
    );
  }
}
