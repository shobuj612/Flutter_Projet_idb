import 'package:flutter/material.dart';
import 'package:menu_bar/model/fabric.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/fabric_service.dart';
import 'package:menu_bar/services/order_service.dart';

class AddFabricScreen extends StatefulWidget {
  final Fabric? fabric;

  const AddFabricScreen({super.key, this.fabric});

  @override
  State<AddFabricScreen> createState() => _AddFabricScreenState();
}

class _AddFabricScreenState extends State<AddFabricScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.fabric != null) {
      _typeController.text = widget.fabric!.fabricType;
      _qtyController.text = widget.fabric!.fabricQty.toString();
      _dateController.text =
          widget.fabric!.receivedDate.toIso8601String().split("T").first;
      _stockController.text = widget.fabric!.availableStock.toString();
      _selectedOrder = widget.fabric!.order;
    }
  }

  Future<void> fetchOrders() async {
    try {
      final orders = await OrderService().getAllOrders();
      if (!mounted) return;
      setState(() {
        _orderList = orders;
      });
    } catch (e) {
      debugPrint("Failed to load orders: $e");
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      Fabric fabric = Fabric(
        fabricId: widget.fabric?.fabricId,
        order: _selectedOrder!,
        fabricType: _typeController.text,
        fabricQty: int.parse(_qtyController.text),
        receivedDate: DateTime.parse(_dateController.text),
        availableStock: int.parse(_stockController.text),
      );

      try {
        if (widget.fabric == null) {
          await FabricService().addFabric(fabric);
        } else {
          await FabricService().updateFabric(fabric);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.fabric == null
                ? 'Fabric added successfully'
                : 'Fabric updated successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _qtyController.dispose();
    _dateController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.fabric != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Fabric" : "Add Fabric")),
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
                    child: Text('${order.orderName} (Qty: ${order.orderQty})'),
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
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Fabric Type'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter type' : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Fabric Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter quantity' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                    labelText: 'Received Date (yyyy-mm-dd)',
                    suffixIcon: Icon(Icons.calendar_today)),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (pickedDate != null) {
                    _dateController.text =
                        pickedDate.toIso8601String().split('T').first;
                  }
                },
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Available Stock'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter stock' : null,
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
