import 'package:flutter/material.dart';

class ShippingListScreen extends StatefulWidget {
  const ShippingListScreen({super.key});

  @override
  State<ShippingListScreen> createState() => _ShippingListScreenState();
}

class _ShippingListScreenState extends State<ShippingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipping List')),
      body: const Center(
        child: Text('List of shipping records will appear here'),
      ),
    );
  }
}
