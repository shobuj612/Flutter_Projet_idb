import 'package:flutter/material.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/model/warehouse.dart';
import 'package:menu_bar/services/order_service.dart';
import 'package:menu_bar/services/warehouse_service.dart';

class AddWarehouseScreen extends StatefulWidget {
  final Warehouse? warehouse;
  const AddWarehouseScreen({super.key, this.warehouse});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _receivedDateController = TextEditingController();
  final TextEditingController _storedQtyController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.warehouse != null) {
      _receivedDateController.text =
          widget.warehouse!.receivedDate.toIso8601String().split("T").first;
      _storedQtyController.text = widget.warehouse!.storedQty.toString();
      _selectedOrder = widget.warehouse!.order;
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
      if (!mounted) return;
      debugPrint("Failed to load orders: $e");
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      final warehouse = Warehouse(
        warehouseId: widget.warehouse?.warehouseId,
        order: _selectedOrder!,
        receivedDate: DateTime.parse(_receivedDateController.text),
        storedQty: int.parse(_storedQtyController.text),
      );

      try {
        if (widget.warehouse == null) {
          await WarehouseService().addWarehouse(warehouse);
        } else {
          await WarehouseService().updateWarehouse(warehouse);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.warehouse == null
                ? 'Warehouse record added'
                : 'Warehouse record updated'),
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
    _receivedDateController.dispose();
    _storedQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.warehouse != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Warehouse" : "Add Warehouse")),
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
                  return DropdownMenuItem(
                    value: order,
                    child: Text('${order.orderName} (Qty: ${order.orderQty})'),
                  );
                }).toList(),
                onChanged: (Order? newOrder) {
                  setState(() {
                    _selectedOrder = newOrder;
                  });
                },
                validator: (val) => val == null ? 'Please select an order' : null,
              ),
              TextFormField(
                controller: _receivedDateController,
                decoration:
                    const InputDecoration(labelText: 'Received Date (yyyy-mm-dd)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter received date' : null,
              ),
              TextFormField(
                controller: _storedQtyController,
                decoration: const InputDecoration(labelText: 'Stored Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter stored quantity' : null,
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
