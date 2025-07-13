import 'package:flutter/material.dart';
import 'package:menu_bar/model/sewing.dart';
import 'package:menu_bar/screens/sewing/add_sewing.dart';
import 'package:menu_bar/services/sewing_service.dart';

class SewingListScreen extends StatefulWidget {
  const SewingListScreen({super.key});

  @override
  State<SewingListScreen> createState() => _SewingListScreenState();
}

class _SewingListScreenState extends State<SewingListScreen> {
  List<Sewing> sewingList = [];
  final SewingService sewingService = SewingService();

  @override
  void initState() {
    super.initState();
    fetchSewingRecords();
  }

  void fetchSewingRecords() async {
    try {
      final data = await sewingService.getAllSewingRecords();
      setState(() {
        sewingList = data;
      });
    } catch (e) {
      debugPrint('Error fetching sewing records: $e');
    }
  }

  void deleteSewing(int id) {
    setState(() {
      sewingService.deleteSewing(id);
    });
  }

  void editSewing(Sewing sewing) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSewingScreen(sewing: sewing),
      ),
    );
    fetchSewingRecords();
  }

  void downloadReport() async {
    try {
      await sewingService.downloadSewingReport();
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
      appBar: AppBar(title: const Text("Sewing List")),
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
                    DataColumn(label: Text("Sewing ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Order Name")),// this is new added
                    DataColumn(label: Text("Order StyleNo")),// this is new added
                    DataColumn(label: Text("Start Date")),
                    DataColumn(label: Text("End Date")),
                    DataColumn(label: Text("Quantity")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: sewingList.map((sewing) {
                    return DataRow(
                      cells: [
                        DataCell(Text(sewing.sewingId?.toString() ?? '')),
                        DataCell(Text(sewing.order.orderId?.toString() ?? '')),
                        DataCell(Text(sewing.order.orderName)),
                        DataCell(Text(sewing.order.styleNo)),
                        DataCell(Text(sewing.sewingStartDate.toLocal().toString().split(' ')[0])),
                        DataCell(Text(sewing.sewingEndDate.toLocal().toString().split(' ')[0])),
                        DataCell(Text(sewing.sewingQty.toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editSewing(sewing),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (sewing.sewingId != null) {
                                  deleteSewing(sewing.sewingId!);
                                }
                              },
                            ),
                          ],
                        )),
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
