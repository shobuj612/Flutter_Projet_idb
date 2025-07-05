import 'package:flutter/material.dart';
import 'package:menu_bar/model/buyer.dart';

class BuyerListScreen extends StatefulWidget {
  const BuyerListScreen({super.key});

  @override
  BuyerListScreenState createState() => BuyerListScreenState();
}

class BuyerListScreenState extends State<BuyerListScreen> {
  List<Buyer> buyers = [];

  void deleteBuyer(Buyer buyer) {
    setState(() {
      buyers.remove(buyer);
    });
  }

  void editBuyer(Buyer buyer) {
    print("Editing buyer: ${buyer.buyerName}");
    // TODO: Navigate to edit screen
  }

  void downloadReport() {
    print("Downloading report...");
    // TODO: Implement PDF/Excel download
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buyer List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: downloadReport,
                child: const Text("Download"),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Buyer ID")),
                    DataColumn(label: Text("Buyer Name")),
                    DataColumn(label: Text("Contact Person")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Phone")),
                    DataColumn(label: Text("Address")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: buyers.map((buyer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(buyer.buyerId?.toString() ?? '')),
                        DataCell(Text(buyer.buyerName)),
                        DataCell(Text(buyer.contactPerson)),
                        DataCell(Text(buyer.email)),
                        DataCell(Text(buyer.phone)),
                        DataCell(Text(buyer.address)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => editBuyer(buyer),
                                icon:const Icon(Icons.edit, color: Colors.green),
                              ),
                              IconButton(
                                onPressed: () => deleteBuyer(buyer),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
