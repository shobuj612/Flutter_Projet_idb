import 'package:flutter/material.dart';
import 'package:menu_bar/model/shipping.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/shippipng_service.dart';
import 'package:menu_bar/services/order_service.dart'; // Make sure this is imported

class AddShippingScreen extends StatefulWidget {
  final Shipping? shipping;
  const AddShippingScreen({super.key, this.shipping});

  @override
  State<AddShippingScreen> createState() => _AddShippingScreenState();
}

class _AddShippingScreenState extends State<AddShippingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shippingDateController = TextEditingController();
  final TextEditingController _shippedQtyController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _carrierController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
    if (widget.shipping != null) {
      _shippingDateController.text = widget.shipping!.shippingDate.toIso8601String().split("T").first;
      _shippedQtyController.text = widget.shipping!.shippedQty.toString();
      _invoiceNoController.text = widget.shipping!.invoiceNo;
      _destinationController.text = widget.shipping!.destination;
      _carrierController.text = widget.shipping!.carrier;
      _selectedOrder = widget.shipping!.order;
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
      debugPrint('Error fetching orders: $e');
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      Shipping shipping = Shipping(
        shippingId: widget.shipping?.shippingId,
        order: _selectedOrder!,
        shippingDate: DateTime.parse(_shippingDateController.text),
        shippedQty: int.parse(_shippedQtyController.text),
        invoiceNo: _invoiceNoController.text,
        destination: _destinationController.text,
        carrier: _carrierController.text,
      );

      try {
        if (widget.shipping == null) {
          await ShippingService().addShipping(shipping);
        } else {
          await ShippingService().updateShipping(shipping);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.shipping == null
                ? 'Shipping record added'
                : 'Shipping record updated'),
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
    _shippingDateController.dispose();
    _shippedQtyController.dispose();
    _invoiceNoController.dispose();
    _destinationController.dispose();
    _carrierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.shipping != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Shipping" : "Add Shipping")),
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
                controller: _shippingDateController,
                decoration:
                    const InputDecoration(labelText: 'Shipping Date (yyyy-mm-dd)'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter shipping date' : null,
              ),
              TextFormField(
                controller: _shippedQtyController,
                decoration: const InputDecoration(labelText: 'Shipped Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter shipped quantity' : null,
              ),
              TextFormField(
                controller: _invoiceNoController,
                decoration: const InputDecoration(labelText: 'Invoice No'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter invoice number' : null,
              ),
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter destination' : null,
              ),
              TextFormField(
                controller: _carrierController,
                decoration: const InputDecoration(labelText: 'Carrier'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter carrier' : null,
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
