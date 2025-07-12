import 'package:flutter/material.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/order_service.dart';

class OrderInformationInFinishing extends StatefulWidget {
  const OrderInformationInFinishing({super.key});
  @override
  OrderInformationInFinishingScreenState createState() =>
      OrderInformationInFinishingScreenState();
}

// this is another class
class OrderInformationInFinishingScreenState
    extends State<OrderInformationInFinishing> {
  List<Order> orders = [];
  bool isLoading = true;
  final OrderService _orderService = OrderService();
  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    try {
      final data = await _orderService.getAllOrders();
      if (!mounted) return;
      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('not find the data :$e');
      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('order information'),
        backgroundColor: Colors.amber,
      ),
      body: isLoading?
      const Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const[
            DataColumn(label: Text('order Id')),
            DataColumn(label: Text('Order Name')),
            DataColumn(label: Text('Buyer Name')),
            DataColumn(label: Text('order quantity')),
            DataColumn(label: Text('order style')),
            DataColumn(label: Text('order date')),
            DataColumn(label: Text('delivery date')),
            DataColumn(label: Text('status'))
          ],
          rows: orders.map((order){
            return DataRow(
              cells:[
                DataCell(Text(order.orderId.toString())),
                DataCell(Text(order.buyer.buyerName)),
                DataCell(Text(order.orderName)),
                DataCell(Text(order.styleNo)),
                DataCell(Text(order.orderQty.toString())),
                DataCell(Text(order.orderDate.toLocal().toString().split(' ')[0])),
                DataCell(Text(order.deliveryDate.toLocal().toString().split(' ')[0])),
                DataCell(Text(order.status)),
              ]);
          }).toList()
        )
      )
    );
  }

}
