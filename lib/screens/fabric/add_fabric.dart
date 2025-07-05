import 'package:flutter/material.dart';

class AddFabricScreen extends StatefulWidget {
  const AddFabricScreen({super.key});

  @override
  State<AddFabricScreen> createState() => _AddFabricScreenState();
}

class _AddFabricScreenState extends State<AddFabricScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Fabric')),
      body: const Center(
        child: Text('Fabric form will appear here'),
      ),
    );
  }
}
