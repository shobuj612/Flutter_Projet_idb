import 'package:flutter/material.dart';
import 'package:menu_bar/model/sewing.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/sewing_service.dart';
import 'package:menu_bar/services/order_service.dart'; // Make sure this is imported

class AddSewingScreen extends StatefulWidget {
  final Sewing? sewing;
  const AddSewingScreen({super.key, this.sewing});

  @override
  State<AddSewingScreen> createState() => _AddSewingScreenState();
}

class _AddSewingScreenState extends State<AddSewingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.sewing != null) {
      _startDateController.text = widget.sewing!.sewingStartDate.toIso8601String().split("T").first;
      _endDateController.text = widget.sewing!.sewingEndDate.toIso8601String().split("T").first;
      _qtyController.text = widget.sewing!.sewingQty.toString();
      _selectedOrder = widget.sewing!.order;
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
      Sewing sewing = Sewing(
        sewingId: widget.sewing?.sewingId,
        order: _selectedOrder!,
        sewingStartDate: DateTime.parse(_startDateController.text),
        sewingEndDate: DateTime.parse(_endDateController.text),
        sewingQty: int.parse(_qtyController.text),
      );

      try {
        if (widget.sewing == null) {
          await SewingService().addSewing(sewing);
        } else {
          await SewingService().updateSewing(sewing);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.sewing == null ? 'Sewing record added' : 'Sewing record updated'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.sewing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Sewing" : "Add Sewing")),
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
                    child: Text('${order.orderName} (ID: ${order.orderId})'),
                  );
                }).toList(),
                onChanged: (Order? newValue) {
                  setState(() {
                    _selectedOrder = newValue;
                  });
                },
                validator: (val) => val == null ? 'Please select an order' : null,
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(labelText: 'Sewing Start Date (yyyy-mm-dd)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter start date' : null,
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(labelText: 'Sewing End Date (yyyy-mm-dd)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter end date' : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Sewing Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Enter quantity' : null,
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
