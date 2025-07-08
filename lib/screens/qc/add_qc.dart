import 'package:flutter/material.dart';
import 'package:menu_bar/model/qc.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/qc_service.dart';
import 'package:menu_bar/services/order_service.dart'; // Import OrderService

class AddQcScreen extends StatefulWidget {
  final QC? qc;

  const AddQcScreen({super.key, this.qc});

  @override
  State<AddQcScreen> createState() => _AddQcScreenState();
}

class _AddQcScreenState extends State<AddQcScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inspectionDateController = TextEditingController();
  final TextEditingController _passedQtyController = TextEditingController();
  final TextEditingController _rejectedQtyController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  Order? _selectedOrder;
  List<Order> _orderList = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders from OrderService

    if (widget.qc != null) {
      _inspectionDateController.text = widget.qc!.inspectionDate.toIso8601String().split("T").first;
      _passedQtyController.text = widget.qc!.passedQty.toString();
      _rejectedQtyController.text = widget.qc!.rejectedQty.toString();
      _remarksController.text = widget.qc!.remarks;
      _selectedOrder = widget.qc!.order;
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
      debugPrint("Failed to load orders: $e");
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate() && _selectedOrder != null) {
      QC qc = QC(
        qcId: widget.qc?.qcId,
        order: _selectedOrder!,
        inspectionDate: DateTime.parse(_inspectionDateController.text),
        passedQty: int.parse(_passedQtyController.text),
        rejectedQty: int.parse(_rejectedQtyController.text),
        remarks: _remarksController.text,
      );

      try {
        if (widget.qc == null) {
          await QcService().addQc(qc);
        } else {
          await QcService().updateQc(qc);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.qc == null ? 'QC record added' : 'QC record updated'),
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
    _inspectionDateController.dispose();
    _passedQtyController.dispose();
    _rejectedQtyController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.qc != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit QC" : "Add QC")),
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
                onChanged: (Order? newOrder) {
                  setState(() {
                    _selectedOrder = newOrder;
                  });
                },
                validator: (val) =>
                    val == null ? 'Please select an order' : null,
              ),
              TextFormField(
                controller: _inspectionDateController,
                decoration: const InputDecoration(labelText: 'Inspection Date (yyyy-mm-dd)'),
                validator: (val) => val == null || val.isEmpty ? 'Enter date' : null,
              ),
              TextFormField(
                controller: _passedQtyController,
                decoration: const InputDecoration(labelText: 'Passed Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Enter passed quantity' : null,
              ),
              TextFormField(
                controller: _rejectedQtyController,
                decoration: const InputDecoration(labelText: 'Rejected Quantity'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Enter rejected quantity' : null,
              ),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: 'Remarks'),
                validator: (val) => val == null || val.isEmpty ? 'Enter remarks' : null,
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
