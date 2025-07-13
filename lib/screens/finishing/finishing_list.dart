import 'package:flutter/material.dart';
import 'package:menu_bar/model/finishing.dart';
import 'package:menu_bar/screens/finishing/add_finishing.dart';
import 'package:menu_bar/services/finishing_service.dart';

class FinishingListScreen extends StatefulWidget {
  const FinishingListScreen({super.key});

  @override
  State<FinishingListScreen> createState() => _FinishingListScreenState();
}

class _FinishingListScreenState extends State<FinishingListScreen> {
  List<Finishing> records = [];
  final FinishingService finishingService = FinishingService();

  @override
  void initState() {
    super.initState();
    fetchFinishing();
  }

  void fetchFinishing() async {
    try {
      final data = await finishingService.getAllFinishing();
      setState(() {
        records = data;
      });
    } catch (e) {
      debugPrint('Error fetching finishing records: $e');
    }
  }

  void deleteFinishing(int id) {
    setState(() {
      finishingService.deleteFinishing(id);
    });
  }

  void editFinishing(Finishing finishing) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFinishingScreen(finishing: finishing),
      ),
    );
    fetchFinishing();
  }

  void downloadReport() async {
    try {
      await finishingService.downloadFinishingReport();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF downloaded and opened')),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finishing List")),
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
                    DataColumn(label: Text("Finishing ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Order Name")),// this is new added
                    DataColumn(label: Text("Order StyleNo")),// this is new added
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Packing")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: records.map((f) {
                    return DataRow(cells: [
                      DataCell(Text(f.finishId?.toString() ?? '')),
                      DataCell(Text(f.order.orderId?.toString() ?? '')),
                      DataCell(Text(f.order.orderName)),
                      DataCell(Text(f.order.styleNo)),
                      DataCell(Text(f.finishingDate.toLocal().toString().split(' ')[0])),
                      DataCell(Text(f.finishQty.toString())),
                      DataCell(Text(f.packingDone)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => editFinishing(f),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (f.finishId != null) {
                                deleteFinishing(f.finishId!);
                              }
                            },
                          ),
                        ],
                      )),
                    ]);
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
