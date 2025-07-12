import 'package:flutter/material.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/screens/marchendising/add_order.dart';
import 'package:menu_bar/services/order_service.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> orders = [];
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final data = await _orderService.getAllOrders();
      if (!mounted) return;
      setState(() => orders = data);
    } catch (e) {
      if (!mounted) return;
      debugPrint("Failed to fetch orders: $e");
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _orderService.deleteOrder(id);
      if (!mounted) return;
      fetchOrders();
    } catch (e) {
      if (!mounted) return;
      debugPrint("Failed to delete order: $e");
    }
  }

  void editOrder(Order order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderScreen(order: order)),
    );
    if (!mounted) return;
    fetchOrders();
  }

  void downloadOrderReport() async {
    try {
      await _orderService.downloadOrderReport();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF downloaded and opened")),
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint("Download error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to download order report")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order List")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: downloadOrderReport,
                child: const Text("Download PDF"),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) => Colors.grey.shade300,
                  ),
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) => Colors.white,
                  ),
                  columns: const [
                    DataColumn(label: Text("Order Id")),
                    DataColumn(label: Text("Order Name")),
                    DataColumn(label: Text("Buyer")),
                    DataColumn(label: Text("Style No")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Order Date")),
                    DataColumn(label: Text("Delivery Date")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: orders.map((order) {
                    return DataRow(
                      cells: [
                         DataCell(Text(order.orderId.toString())),
                        DataCell(Text(order.orderName)),
                        DataCell(Text(order.buyer.buyerName)),
                        DataCell(Text(order.styleNo)),
                        DataCell(Text(order.orderQty.toString())),
                        DataCell(Text(order.orderDate.toLocal().toString().split(' ')[0])),
                        DataCell(Text(order.deliveryDate.toLocal().toString().split(' ')[0])),
                        DataCell(Text(order.status)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => editOrder(order),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (order.orderId != null) {
                                  deleteOrder(order.orderId!);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddOrderScreen()),
          );
          if (!mounted) return;
          fetchOrders();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
