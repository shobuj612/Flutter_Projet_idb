import 'package:flutter/material.dart';

class AddFinishingScreen extends StatefulWidget {
  const AddFinishingScreen({super.key});

  @override
  State<AddFinishingScreen> createState() => _AddFinishingScreenState();
}

class _AddFinishingScreenState extends State<AddFinishingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Finishing')),
      body: const Center(
        child: Text('Finishing form will appear here'),
      ),
    );
  }
}
