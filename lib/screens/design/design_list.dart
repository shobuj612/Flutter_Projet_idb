import 'package:flutter/material.dart';
import 'package:menu_bar/model/design.dart';
import 'package:menu_bar/screens/design/add_design.dart';
import 'package:menu_bar/services/design_service.dart';

class DesignListScreen extends StatefulWidget {
  const DesignListScreen({super.key});

  @override
  State<DesignListScreen> createState() => _DesignListScreenState();
}

class _DesignListScreenState extends State<DesignListScreen> {
  List<Design> designs = [];
  final DesignService designService = DesignService();

  @override
  void initState() {
    super.initState();
    fetchDesigns();
  }

  void fetchDesigns() async {
    try {
      final data = await designService.getAllDesigns();
      setState(() {
        designs = data;
      });
    } catch (e) {
      debugPrint('Error fetching designs: $e');
    }
  }

  void deleteDesign(int id) {
    setState(() {
      designService.deleteDesign(id);
    });
  }

  void editDesign(Design design) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDesignScreen(design: design),
      ),
    );
    fetchDesigns();
  }

  void downloadReport() async {
    try {
      await designService.downloadDesignReport();
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
      appBar: AppBar(title: const Text("Design List")),
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
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Image URL")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Remarks")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: designs.map((design) {
                    return DataRow(
                      cells: [
                        DataCell(Text(design.designId?.toString() ?? '')),
                        DataCell(Text(design.order.orderId?.toString() ?? '')),
                        DataCell(Text(design.designName)),
                        DataCell(Text(design.designImageUrl)),
                        DataCell(Text(design.status)),
                        DataCell(Text(design.remarks)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editDesign(design),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (design.designId != null) {
                                  deleteDesign(design.designId!);
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
