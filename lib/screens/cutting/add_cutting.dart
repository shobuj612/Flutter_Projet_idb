import 'package:flutter/material.dart';
import 'package:menu_bar/model/cutting.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/cutting_service.dart';
import 'package:menu_bar/services/order_service.dart';

class AddCuttingScreen extends StatefulWidget {
  final Cutting? cutting;

  const AddCuttingScreen({super.key, this.cutting});

  @override
  State<AddCuttingScreen> createState() => _AddCuttingScreenState();
}

class _AddCuttingScreenState extends State<AddCuttingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.cutting != null) {
      _startDateController.text =
          widget.cutting!.cuttingStartDate.toIso8601String().split("T").first;
      _endDateController.text =
          widget.cutting!.cuttingEndDate.toIso8601String().split("T").first;
      _qtyController.text = widget.cutting!.cuttingQty.toString();
      _supervisorController.text = widget.cutting!.supervisorName;
      _selectedOrder = widget.cutting!.order;
    }
  }

  Future<void> fetchOrders() async {
    try {
      final data = await OrderService().getAllOrders();
      if (!mounted) return;
      setState(() {
        _orderList = data;
      });
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      try {
        final cutting = Cutting(
          cuttingId: widget.cutting?.cuttingId,
          order: _selectedOrder!,
          cuttingStartDate: DateTime.parse(_startDateController.text),
          cuttingEndDate: DateTime.parse(_endDateController.text),
          cuttingQty: int.parse(_qtyController.text),
          supervisorName: _supervisorController.text,
        );

        if (widget.cutting == null) {
          await CuttingService().addCutting(cutting);
        } else {
          await CuttingService().updateCutting(cutting);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.cutting == null
                  ? 'Cutting added successfully'
                  : 'Cutting updated successfully',
            ),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _qtyController.dispose();
    _supervisorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cutting != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Cutting" : "Add Cutting")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Order>(
                value: _selectedOrder,
                decoration: const InputDecoration(labelText: 'Select Order'),
                items: _orderList.map((order) {
                  return DropdownMenuItem<Order>(
                    value: order,
                    child: Text('Order: ${order.orderName}'),
                  );
                }).toList(),
                onChanged: (Order? value) {
                  setState(() {
                    _selectedOrder = value;
                  });
                },
                validator: (val) =>
                    val == null ? 'Please select an order' : null,
              ),
              TextFormField(
                controller: _startDateController,
                decoration:
                    const InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter start date' : null,
              ),
              TextFormField(
                controller: _endDateController,
                decoration:
                    const InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter end date' : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Cutting Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter quantity' : null,
              ),
              TextFormField(
                controller: _supervisorController,
                decoration:
                    const InputDecoration(labelText: 'Supervisor Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter supervisor name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text(isEdit ? "Update" : "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
