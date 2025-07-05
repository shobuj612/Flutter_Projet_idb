import 'package:flutter/material.dart';

class FinishingListScreen extends StatefulWidget {
  const FinishingListScreen({super.key});

  @override
  State<FinishingListScreen> createState() => _FinishingListScreenState();
}

class _FinishingListScreenState extends State<FinishingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finishing List')),
      body: const Center(
        child: Text('List of finishing records will appear here'),
      ),
    );
  }
}
