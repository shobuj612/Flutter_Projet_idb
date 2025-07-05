import 'package:flutter/material.dart';

class AddCuttingScreen extends StatefulWidget {
  const AddCuttingScreen({super.key});

  @override
  State<AddCuttingScreen> createState() => _AddCuttingScreenState();
}

class _AddCuttingScreenState extends State<AddCuttingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cutting Details')),
      body: const Center(
        child: Text('Cutting form will appear here'),
      ),
    );
  }
}
