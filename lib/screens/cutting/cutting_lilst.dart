import 'package:flutter/material.dart';
import 'package:menu_bar/model/cutting.dart';
import 'package:menu_bar/screens/cutting/add_cutting.dart';
import 'package:menu_bar/services/cutting_service.dart';

class CuttingListScreen extends StatefulWidget {
  const CuttingListScreen({super.key});

  @override
  State<CuttingListScreen> createState() => _CuttingListScreenState();
}

class _CuttingListScreenState extends State<CuttingListScreen> {
  List<Cutting> cuttings = [];
  final CuttingService cuttingService = CuttingService();

  @override
  void initState() {
    super.initState();
    fetchAllCuttings();
  }

  void fetchAllCuttings() async {
    try {
      final data = await cuttingService.getAllCuttings();
      setState(() {
        cuttings = data;
      });
    } catch (e) {
      debugPrint('Error fetching cuttings: $e');
    }
  }

  void deleteCutting(int id) {
    setState(() {
      cuttingService.deleteCutting(id);
    });
  }

  void editCutting(Cutting cutting) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCuttingScreen(cutting: cutting),
      ),
    );
    fetchAllCuttings();
  }

  void downloadReport() async {
    try {
      await cuttingService.downloadCuttingReport();
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
      appBar: AppBar(title: const Text("Cutting List")),
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
                    DataColumn(label: Text("Cutting ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Order Name")),// this is new added
                    DataColumn(label: Text("Order StyleNo")),// this new added
                    DataColumn(label: Text("Start Date")),
                    DataColumn(label: Text("End Date")),
                    DataColumn(label: Text("Cutting Quantity")),
                    DataColumn(label: Text("Supervisor")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: cuttings.map((cutting) {
                    return DataRow(
                      cells: [
                        DataCell(Text(cutting.cuttingId?.toString() ?? '')),
                        DataCell(Text(cutting.order.orderId?.toString() ?? '')),
                        DataCell(Text(cutting.order.orderName)),
                        DataCell(Text(cutting.order.styleNo)),
                        DataCell(Text(cutting.cuttingStartDate.toIso8601String())),
                        DataCell(Text(cutting.cuttingEndDate.toIso8601String())),
                        DataCell(Text(cutting.cuttingQty.toString())),
                        DataCell(Text(cutting.supervisorName)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editCutting(cutting),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (cutting.cuttingId != null) {
                                  deleteCutting(cutting.cuttingId!);
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
