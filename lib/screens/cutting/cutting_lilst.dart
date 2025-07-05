import 'package:flutter/material.dart';

class CuttingListScreen extends StatefulWidget {
  const CuttingListScreen({super.key});

  @override
  State<CuttingListScreen> createState() => _CuttingListScreenState();
}

class _CuttingListScreenState extends State<CuttingListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cutting List')),
      body: const Center(
        child: Text('List of cuttings will be shown here'),
      ),
    );
  }
}
