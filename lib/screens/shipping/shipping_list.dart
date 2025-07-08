import 'package:flutter/material.dart';
import 'package:menu_bar/model/shipping.dart';
import 'package:menu_bar/screens/shipping/add_shipping.dart';
//import 'package:menu_bar/services/shipping_service.dart';
import 'package:menu_bar/services/shippipng_service.dart';

class ShippingListScreen extends StatefulWidget {
  const ShippingListScreen({super.key});

  @override
  State<ShippingListScreen> createState() => _ShippingListScreenState();
}

class _ShippingListScreenState extends State<ShippingListScreen> {
  List<Shipping> shippings = [];
  final ShippingService shippingService = ShippingService();

  @override
  void initState() {
    super.initState();
    fetchAllShippingRecords();
  }

  void fetchAllShippingRecords() async {
    try {
      final data = await shippingService.getAllShippingRecords();
      if (!mounted) return;
      setState(() {
        shippings = data;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('Error fetching shipping records: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch shipping records')),
      );
    }
  }

  void deleteShipping(int shippingId) async {
    try {
      await shippingService.deleteShipping(shippingId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipping record deleted')),
      );
      fetchAllShippingRecords();
    } catch (e) {
      if (!mounted) return;
      debugPrint('Error deleting shipping record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete shipping record')),
      );
    }
  }

  void editShipping(Shipping shipping) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShippingScreen(shipping: shipping),
      ),
    );
    if (!mounted) return;
    fetchAllShippingRecords();
  }

  void downloadReport() async {
    try {
      await shippingService.downloadShippingReport();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shipping report downloaded and opened')),
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
      appBar: AppBar(title: const Text('Shipping List')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: downloadReport,
                child: const Text('Download Report'),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Shipping ID')),
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Shipping Date')),
                    DataColumn(label: Text('Shipped Qty')),
                    DataColumn(label: Text('Invoice No')),
                    DataColumn(label: Text('Destination')),
                    DataColumn(label: Text('Carrier')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: shippings.map((shipping) {
                    return DataRow(
                      cells: [
                        DataCell(Text(shipping.shippingId?.toString() ?? '')),
                        DataCell(Text(shipping.order.orderId.toString())),
                        DataCell(Text(
                            shipping.shippingDate.toIso8601String().split('T').first)),
                        DataCell(Text(shipping.shippedQty.toString())),
                        DataCell(Text(shipping.invoiceNo)),
                        DataCell(Text(shipping.destination)),
                        DataCell(Text(shipping.carrier)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.green),
                                onPressed: () => editShipping(shipping),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (shipping.shippingId != null) {
                                    deleteShipping(shipping.shippingId!);
                                  }
                                },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddShippingScreen()),
          );
          if (!mounted) return;
          fetchAllShippingRecords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
