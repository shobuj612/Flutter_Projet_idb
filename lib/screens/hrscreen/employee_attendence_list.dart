import 'package:flutter/material.dart';

class EmployeeAttendenceListScreen extends StatefulWidget {
  const EmployeeAttendenceListScreen({super.key});

  @override
  State<EmployeeAttendenceListScreen> createState() => _EmployeeAttendenceListScreenState();
}

class _EmployeeAttendenceListScreenState extends State<EmployeeAttendenceListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Attendance List')),
      body: const Center(
        child: Text('Employee attendance records will appear here'),
      ),
    );
  }
}
