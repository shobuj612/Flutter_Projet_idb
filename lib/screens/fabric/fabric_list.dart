import 'package:flutter/material.dart';

class FabricListScreen extends StatefulWidget {
  const FabricListScreen({super.key});

  @override
  State<FabricListScreen> createState() => _FabricListScreenState();
}

class _FabricListScreenState extends State<FabricListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fabric List')),
      body: const Center(
        child: Text('List of fabrics will be shown here'),
      ),
    );
  }
}
