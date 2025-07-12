import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/order_service.dart';

class OrderInformationInFabric extends StatefulWidget {
  const OrderInformationInFabric({super.key});
  @override
  OrderInformationInFabricScreenState createState() =>
      OrderInformationInFabricScreenState();
}

// this is outside the class
class OrderInformationInFabricScreenState
    extends State<OrderInformationInFabric> {
  List<Order> orders = [];
  bool isloading = true; // this is to loading the from the database
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
      setState(() {
        orders = data;
        isloading = false;
      });
    } catch (e) {
      debugPrint('not found the data:$e');
      isloading = false;
    }
  } // this is the end of the method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('order information'),
        backgroundColor: Colors.cyanAccent,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: const [
                  DataColumn(label: Text('order Id')),
                  DataColumn(label: Text('Order Name')),
                  DataColumn(label: Text('Buyer Name')),
                  DataColumn(label: Text('order style')),
                  DataColumn(label: Text('order quantity')),
                  DataColumn(label: Text('order date')),
                  DataColumn(label: Text('order delivery date')),
                  DataColumn(label: Text('status'))
                ],
                  rows: orders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order.orderId.toString())),
                      DataCell(Text(order.buyer.buyerName)),
                      DataCell(Text(order.orderName)),
                      DataCell(Text(order.styleNo)),
                      DataCell(Text(order.orderQty.toString())),
                      DataCell(Text(
                          order.orderDate.toLocal().toString().split(' ')[0])),
                      DataCell(Text(order.deliveryDate
                          .toLocal()
                          .toString()
                          .split(' ')[0])),
                          DataCell(Text(order.status))
                    ]);
                  }).toList())),
    );
  }
}
