import 'package:flutter/material.dart';

class  MarchDashboardScreen extends StatefulWidget {
  const MarchDashboardScreen({super.key});

  @override
  State<MarchDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<MarchDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Text('Dashboard content goes here'),
      ),
    );
  }
}
