import 'package:flutter/material.dart';

class AddSewingScreen extends StatefulWidget {
  const AddSewingScreen({super.key});

  @override
  State<AddSewingScreen> createState() => _AddSewingScreenState();
}

class _AddSewingScreenState extends State<AddSewingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sewing')),
      body: const Center(
        child: Text('Sewing form will appear here'),
      ),
    );
  }
}
