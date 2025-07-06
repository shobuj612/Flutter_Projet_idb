import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';
import 'package:menu_bar/services/buyer_service.dart';

class AddBuyerScreen extends StatefulWidget {
  final Buyer? buyer; // 👈 For edit mode, this will be passed

  const AddBuyerScreen({super.key, this.buyer});

  @override
  AddBuyerScreenState createState() => AddBuyerScreenState();
}

class AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 👇 Prefill the fields if editing
    if (widget.buyer != null) {
      _buyerNameController.text = widget.buyer!.buyerName;
      _contactPersonController.text = widget.buyer!.contactPerson;
      _emailController.text = widget.buyer!.email;
      _phoneController.text = widget.buyer!.phone;
      _addressController.text = widget.buyer!.address;
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.buyer != null) {
          // 👇 UPDATE mode
          Buyer updatedBuyer = Buyer(
            buyerId: widget.buyer!.buyerId,
            buyerName: _buyerNameController.text,
            contactPerson: _contactPersonController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            address: _addressController.text,
          );

          await ApiService().updateBuyer(updatedBuyer);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer updated successfully')),
          );
        } else {
          // 👇 ADD mode
          Buyer newBuyer = Buyer(
            buyerName: _buyerNameController.text,
            contactPerson: _contactPersonController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            address: _addressController.text,
          );

          await ApiService().addBuyer(newBuyer);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buyer added successfully')),
          );
        }

        Navigator.pop(context); // 👈 Go back to list screen
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
    // Always dispose controllers
    _buyerNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buyer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Buyer" : "Add Buyer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _buyerNameController,
                decoration: const InputDecoration(labelText: "Buyer Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter buyer name" : null,
              ),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(labelText: "Contact Person"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter contact person" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter phone" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter address" : null,
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

/*
import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';
import 'package:menu_bar/services/buyer_service.dart';

class AddBuyerScreen extends StatefulWidget {
  const AddBuyerScreen({super.key});

  @override
  AddBuyerScreenState createState() => AddBuyerScreenState();
}

class AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create Buyer object from input values
      Buyer buyer = Buyer(
        buyerName: _buyerNameController.text,
        contactPerson: _contactPersonController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );

      try {
        await ApiService().addBuyer(buyer);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buyer added successfully')),
        );

        // Clear fields after successful submission
        _buyerNameController.clear();
        _contactPersonController.clear();
        _emailController.clear();
        _phoneController.clear();
        _addressController.clear();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Buyer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _buyerNameController,
                decoration: const InputDecoration(labelText: "Buyer Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter buyer name" : null,
              ),
              TextFormField(
                controller: _contactPersonController,
                decoration: const InputDecoration(labelText: "Contact Person"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter contact person" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter phone" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
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

*/

/*
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';
import 'package:menu_bar/services/buyer_service.dart';

class AddBuyerScreen extends StatefulWidget {
  const AddBuyerScreen({super.key});
  @override
  AddBuyerScreenState createState() => AddBuyerScreenState();
}

//  FIXED: Moved this class **outside** of AddBuyerScreen
class AddBuyerScreenState extends State<AddBuyerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // ✅ Fixed SnackBar typo
  void submitForm() async{
    if (_formKey.currentState!.validate()) {
      String a = _buyerNameController.text;
      String b = _contactPersonController.text;
      String c = _emailController.text;
      String d = _phoneController.text;
      String e = _addressController.text;

      Buyer buyer =
          Buyer(buyerName: a, contactPerson: b, email: c, phone: d, address: e);
          try{
           await ApiService().addBuyer(buyer);
           if(!mounted) return;
           ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('added successfully'),));
          }// this is end of try
          catch(e){
           if(!mounted) return;
           ScaffoldMessenger.of(context).showSnackBar(  SnackBar(content: Text('Error:$e'),));
          }// this is end of catch
      //print('Submitting: ${buyer.toJson()}');
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
                decoration: const InputDecoration(labelText: "Contact Person"),
                onChanged: (val) => buyer.contactPerson = val,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter contact person" : null,
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
*/