import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';

class AddBuyerScreen extends StatefulWidget {
  const AddBuyerScreen({super.key});
  @override
  AddBuyerScreenState createState() => AddBuyerScreenState();
}

//  FIXED: Moved this class **outside** of AddBuyerScreen
class AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();

  Buyer buyer = Buyer(
    buyerName: '',
    contactPerson: '',
    email: '',
    phone: '',
    address: '',
  );

  // ✅ Fixed SnackBar typo
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Submitting: ${buyer.toJson()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Buyer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // ✅ Fixed: EdgeInsets
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Buyer Name"),
                onChanged: (val) => buyer.buyerName = val,
                validator: (val) =>
                val == null || val.isEmpty ? "Enter buyer name" : null,
              ),
              TextFormField(
                decoration:
                const InputDecoration(labelText: "Contact Person"),
                onChanged: (val) => buyer.contactPerson = val,
                validator: (val) => val == null || val.isEmpty
                    ? "Enter contact person"
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => buyer.email = val,
                validator: (val) =>
                val == null || val.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (val) => buyer.phone = val,
                validator: (val) =>
                val == null || val.isEmpty ? "Enter phone" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Address"),
                onChanged: (val) => buyer.address = val,
                validator: (val) =>
                val == null || val.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
