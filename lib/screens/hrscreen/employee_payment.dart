import 'package:flutter/material.dart';

class EmployeePaymentScreen extends StatefulWidget {
  const EmployeePaymentScreen({super.key});

  @override
  State<EmployeePaymentScreen> createState() => _EmployeePaymentScreenState();
}

class _EmployeePaymentScreenState extends State<EmployeePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Payment')),
      body: const Center(
        child: Text('Employee payment details will appear here'),
      ),
    );
  }
}
