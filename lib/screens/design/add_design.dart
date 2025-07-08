import 'package:flutter/material.dart';
import 'package:menu_bar/model/design.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/design_service.dart';
import 'package:menu_bar/services/order_service.dart';

class AddDesignScreen extends StatefulWidget {
  final Design? design;

  const AddDesignScreen({super.key, this.design});

  @override
  State<AddDesignScreen> createState() => _AddDesignScreenState();
}

class _AddDesignScreenState extends State<AddDesignScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.design != null) {
      _nameController.text = widget.design!.designName;
      _imageUrlController.text = widget.design!.designImageUrl;
      _statusController.text = widget.design!.status;
      _remarksController.text = widget.design!.remarks;
      _selectedOrder = widget.design!.order;
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
      debugPrint("Error loading orders: $e");
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      final design = Design(
        designId: widget.design?.designId,
        order: _selectedOrder!,
        designName: _nameController.text,
        designImageUrl: _imageUrlController.text,
        status: _statusController.text,
        remarks: _remarksController.text,
      );

      try {
        if (widget.design == null) {
          await DesignService().addDesign(design);
        } else {
          await DesignService().updateDesign(design);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.design == null
                ? 'Design added successfully'
                : 'Design updated successfully'),
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
    _nameController.dispose();
    _imageUrlController.dispose();
    _statusController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.design != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Design" : "Add Design")),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Design Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration:
                    const InputDecoration(labelText: 'Design Image URL'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter image URL' : null,
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter status' : null,
              ),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter remarks' : null,
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
