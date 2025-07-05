import 'package:flutter/material.dart';

class ProductionDashboard extends StatefulWidget {
  const ProductionDashboard({super.key});

  @override
  State<ProductionDashboard> createState() => _ProductionDashboardState();
}

class _ProductionDashboardState extends State<ProductionDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production Dashboard')),
      body: const Center(
        child: Text('Production data will appear here'),
      ),
    );
  }
}
