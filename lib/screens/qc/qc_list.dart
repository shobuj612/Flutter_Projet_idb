import 'package:flutter/material.dart';

class QcListScreen extends StatefulWidget {
  const QcListScreen({super.key});

  @override
  State<QcListScreen> createState() => _QcListScreenState();
}

class _QcListScreenState extends State<QcListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QC List')),
      body: const Center(
        child: Text('List of QC records will appear here'),
      ),
    );
  }
}
