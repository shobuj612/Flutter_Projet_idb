import 'package:flutter/material.dart';
import 'package:menu_bar/model/finishing.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/finishing_service.dart';
import 'package:menu_bar/services/order_service.dart';

class AddFinishingScreen extends StatefulWidget {
  final Finishing? finishing;

  const AddFinishingScreen({super.key, this.finishing});

  @override
  State<AddFinishingScreen> createState() => _AddFinishingScreenState();
}

class _AddFinishingScreenState extends State<AddFinishingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _packingController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    if (widget.finishing != null) {
      _dateController.text = widget.finishing!.finishingDate.toIso8601String().split("T").first;
      _qtyController.text = widget.finishing!.finishQty.toString();
      _packingController.text = widget.finishing!.packingDone;
      _selectedOrder = widget.finishing!.order;
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
      debugPrint("Error fetching orders: $e");
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      Finishing finishing = Finishing(
        finishId: widget.finishing?.finishId,
        order: _selectedOrder!,
        finishingDate: DateTime.parse(_dateController.text),
        finishQty: int.parse(_qtyController.text),
        packingDone: _packingController.text,
      );

      try {
        if (widget.finishing == null) {
          await FinishingService().addFinishing(finishing);
        } else {
          await FinishingService().updateFinishing(finishing);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.finishing == null
                ? 'Finishing added successfully'
                : 'Finishing updated successfully'),
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
    _dateController.dispose();
    _qtyController.dispose();
    _packingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.finishing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Finishing" : "Add Finishing")),
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
                onChanged: (Order? newOrder) {
                  setState(() {
                    _selectedOrder = newOrder;
                  });
                },
                validator: (val) =>
                    val == null ? 'Please select an order' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    const InputDecoration(labelText: 'Finishing Date (yyyy-mm-dd)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Finished Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Enter quantity' : null,
              ),
              TextFormField(
                controller: _packingController,
                decoration: const InputDecoration(labelText: 'Packing Done'),
                validator: (val) => val == null || val.isEmpty ? 'Enter packing status' : null,
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
