import 'package:flutter/material.dart';

class AddQcScreen extends StatefulWidget {
  const AddQcScreen({super.key});

  @override
  State<AddQcScreen> createState() => _AddQcScreenState();
}

class _AddQcScreenState extends State<AddQcScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add QC')),
      body: const Center(
        child: Text('QC form will appear here'),
      ),
    );
  }
}
