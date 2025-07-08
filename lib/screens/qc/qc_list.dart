import 'package:flutter/material.dart';
import 'package:menu_bar/model/qc.dart';
import 'package:menu_bar/screens/qc/add_qc.dart';
import 'package:menu_bar/services/qc_service.dart';

class QcListScreen extends StatefulWidget {
  const QcListScreen({super.key});

  @override
  State<QcListScreen> createState() => _QcListScreenState();
}

class _QcListScreenState extends State<QcListScreen> {
  List<QC> qcList = [];
  final QcService qcService = QcService();

  @override
  void initState() {
    super.initState();
    fetchQcRecords();
  }

  void fetchQcRecords() async {
    try {
      final data = await qcService.getAllQcRecords();
      setState(() {
        qcList = data;
      });
    } catch (e) {
      debugPrint('Error fetching QC records: $e');
    }
  }

  void deleteQc(int id) {
    setState(() {
      qcService.deleteQc(id);
    });
  }

  void editQc(QC qc) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQcScreen(qc: qc),
      ),
    );
    fetchQcRecords();
  }

  void downloadReport() async {
    try {
      await qcService.downloadQcReport();
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
      appBar: AppBar(title: const Text("QC List")),
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
                    DataColumn(label: Text("QC ID")),
                    DataColumn(label: Text("Order ID")),
                    DataColumn(label: Text("Inspection Date")),
                    DataColumn(label: Text("Passed Qty")),
                    DataColumn(label: Text("Rejected Qty")),
                    DataColumn(label: Text("Remarks")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: qcList.map((qc) {
                    return DataRow(
                      cells: [
                        DataCell(Text(qc.qcId?.toString() ?? '')),
                        DataCell(Text(qc.order.orderId?.toString() ?? '')),
                        DataCell(Text(qc.inspectionDate.toLocal().toString().split(' ')[0])),
                        DataCell(Text(qc.passedQty.toString())),
                        DataCell(Text(qc.rejectedQty.toString())),
                        DataCell(Text(qc.remarks)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editQc(qc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (qc.qcId != null) {
                                  deleteQc(qc.qcId!);
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
