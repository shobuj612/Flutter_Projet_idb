import 'package:flutter/material.dart';

class OrderListScreenByAdmin extends StatefulWidget {
  const OrderListScreenByAdmin({super.key});

  @override
  State<OrderListScreenByAdmin> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreenByAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order List')),
      body: const Center(
        child: Text('Order list will appear here'),
      ),
    );
  }
}
