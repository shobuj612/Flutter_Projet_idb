import 'package:flutter/material.dart';

class SewingListScreen extends StatefulWidget {
  const SewingListScreen({super.key});

  @override
  State<SewingListScreen> createState() => _SewingListScreenState();
}

class _SewingListScreenState extends State<SewingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sewing List')),
      body: const Center(
        child: Text('List of sewing records will appear here'),
      ),
    );
  }
}
