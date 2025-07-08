import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/order_service.dart';
import 'package:menu_bar/services/buyer_service.dart';

class AddOrderScreen extends StatefulWidget {
  final Order? order;

  const AddOrderScreen({super.key, this.order});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orderNameController = TextEditingController();
  final _styleNoController = TextEditingController();
  final _orderQtyController = TextEditingController();
  final _statusController = TextEditingController();

  DateTime? _orderDate;
  DateTime? _deliveryDate;

  Buyer? selectedBuyer;
  List<Buyer> buyers = [];

  @override
  void initState() {
    super.initState();
    fetchBuyers();

    if (widget.order != null) {
      final order = widget.order!;
      selectedBuyer = order.buyer;
      _orderNameController.text = order.orderName;
      _styleNoController.text = order.styleNo;
      _orderQtyController.text = order.orderQty.toString();
      _statusController.text = order.status;
      _orderDate = order.orderDate;
      _deliveryDate = order.deliveryDate;
    }
  }

  Future<void> fetchBuyers() async {
    try {
      final data = await ApiService().getAllBuyers();
      if (!mounted) return;
      setState(() {
        buyers = data;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint("Failed to load buyers: $e");
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() || selectedBuyer == null) return;

    final order = Order(
      orderId: widget.order?.orderId,
      buyer: selectedBuyer!,
      orderName: _orderNameController.text,
      styleNo: _styleNoController.text,
      orderQty: int.parse(_orderQtyController.text),
      orderDate: _orderDate!,
      deliveryDate: _deliveryDate!,
      status: _statusController.text,
    );

    try {
      if (widget.order == null) {
        await OrderService().addOrder(order);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order added")),
        );
      } else {
        await OrderService().updateOrder(order);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order updated")),
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      debugPrint("Order error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> pickDate(bool isOrderDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isOrderDate ? _orderDate ?? DateTime.now() : _deliveryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (!mounted) return;
      setState(() {
        if (isOrderDate) {
          _orderDate = picked;
        } else {
          _deliveryDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _orderNameController.dispose();
    _styleNoController.dispose();
    _orderQtyController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.order != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Order" : "Add Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<Buyer>(
                value: selectedBuyer,
                items: buyers.map((b) {
                  return DropdownMenuItem(value: b, child: Text(b.buyerName));
                }).toList(),
                onChanged: (val) => setState(() => selectedBuyer = val),
                decoration: const InputDecoration(labelText: "Select Buyer"),
                validator: (val) => val == null ? "Select a buyer" : null,
              ),
              TextFormField(
                controller: _orderNameController,
                decoration: const InputDecoration(labelText: "Order Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter order name" : null,
              ),
              TextFormField(
                controller: _styleNoController,
                decoration: const InputDecoration(labelText: "Style No"),
                validator: (val) => val == null || val.isEmpty ? "Enter style no" : null,
              ),
              TextFormField(
                controller: _orderQtyController,
                decoration: const InputDecoration(labelText: "Order Quantity"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Enter quantity" : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: "Status"),
                validator: (val) => val == null || val.isEmpty ? "Enter status" : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_orderDate == null
                    ? "Pick Order Date"
                    : "Order Date: ${_orderDate!.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => pickDate(true),
              ),
              ListTile(
                title: Text(_deliveryDate == null
                    ? "Pick Delivery Date"
                    : "Delivery Date: ${_deliveryDate!.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => pickDate(false),
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
