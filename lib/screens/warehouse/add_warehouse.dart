import 'package:flutter/material.dart';

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Warehouse')),
      body: const Center(
        child: Text('Warehouse form will appear here'),
      ),
    );
  }
}
