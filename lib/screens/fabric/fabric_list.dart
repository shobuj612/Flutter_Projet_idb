import 'package:flutter/material.dart';
import 'package:menu_bar/model/fabric.dart';
import 'package:menu_bar/screens/fabric/add_fabric.dart';
import 'package:menu_bar/services/fabric_service.dart';

class FabricListScreen extends StatefulWidget {
  const FabricListScreen({super.key});

  @override
  State<FabricListScreen> createState() => _FabricListScreenState();
}

class _FabricListScreenState extends State<FabricListScreen> {
  List<Fabric> fabrics = [];
  final FabricService fabricService = FabricService();

  @override
  void initState() {
    super.initState();
    fetchFabrics();
  }

  void fetchFabrics() async {
    try {
      final data = await fabricService.getAllFabrics();
      setState(() {
        fabrics = data;
      });
    } catch (e) {
      debugPrint('Error fetching fabrics: $e');
    }
  }

  void deleteFabric(int id) {
    setState(() {
      fabricService.deleteFabric(id);
    });
  }

  void editFabric(Fabric fabric) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFabricScreen(fabric: fabric),
      ),
    );
    fetchFabrics();
  }

  void downloadReport() async {
    try {
      await fabricService.downloadFabricReport();
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
      appBar: AppBar(title: const Text("Fabric List")),
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
                    DataColumn(label: Text("Fabric ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Order Name")),// this is new added
                    DataColumn(label: Text("Order StyleNo")),// this is new added
                    DataColumn(label: Text("Type")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Received")),
                    DataColumn(label: Text("Stock")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: fabrics.map((fabric) {
                    return DataRow(
                      cells: [
                        DataCell(Text(fabric.fabricId?.toString() ?? '')),
                        DataCell(Text(fabric.order.orderId?.toString() ?? '')),
                        DataCell(Text(fabric.order.orderName)),
                        DataCell(Text(fabric.order.styleNo)),
                        DataCell(Text(fabric.fabricType)),
                        DataCell(Text(fabric.fabricQty.toString())),
                        DataCell(Text(fabric.receivedDate.toLocal().toString().split(" ")[0])),
                        DataCell(Text(fabric.availableStock.toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editFabric(fabric),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (fabric.fabricId != null) {
                                  deleteFabric(fabric.fabricId!);
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
