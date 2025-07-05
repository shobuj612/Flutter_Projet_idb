import 'package:flutter/material.dart';

class DesignListScreen extends StatefulWidget {
  const DesignListScreen({super.key});

  @override
  State<DesignListScreen> createState() => _DesignListScreenState();
}

class _DesignListScreenState extends State<DesignListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design List')),
      body: const Center(
        child: Text('List of designs will appear here'),
      ),
    );
  }
}
