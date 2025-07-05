import 'package:flutter/material.dart';

class AddDesignScreen extends StatefulWidget {
  const AddDesignScreen({super.key});

  @override
  State<AddDesignScreen> createState() => _AddDesignScreenState();
}

class _AddDesignScreenState extends State<AddDesignScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Design')),
      body: const Center(
        child: Text('Design form will appear here'),
      ),
    );
  }
}
