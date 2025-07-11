import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/order_service.dart';

class OrderInformationInCutting extends StatefulWidget {
  const OrderInformationInCutting({super.key});
  @override
  OrderInformationInCuttingScreenState createState() =>
      OrderInformationInCuttingScreenState();
}

class OrderInformationInCuttingScreenState
    extends State<OrderInformationInCutting> {
  // this is the functional login about the table
  List<Order> orders = [];
  final OrderService _orderService = OrderService();
  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  //Futuer is used to asynchronous operation.that takes much times
  Future<void> fetchAllOrders() async {
    try {
      final data = await _orderService.getAllOrders();
      if (!mounted) return;
      setState(() => orders = data);
    } catch (e) {
      if (!mounted) return;
      debugPrint('not found the data:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Order Information"),
      backgroundColor:Colors.green,
    ),
    body:SingleChildScrollView(
     scrollDirection: Axis.horizontal,
      child:DataTable(
      columns: const[
       DataColumn(label: Text('Order Name')),
       DataColumn(label: Text('Buyer')),
       DataColumn(label: Text('Style_no')),
       DataColumn(label: Text('Qty')),
       DataColumn(label: Text('Order date')),
       DataColumn(label: Text('Delivery Date')),
       DataColumn(label: Text('status')),
    ],
    rows:orders.map((order){
     return DataRow(
      cells:[
        DataCell(Text(order.orderName)),
        DataCell(Text(order.buyer.buyerName)),
        DataCell(Text(order.styleNo)),
        DataCell(Text(order.orderQty.toString())),
        DataCell(Text(order.orderDate.toLocal().toString().split(' ')[0])),
        DataCell(Text(order.deliveryDate.toLocal().toString().split(' ')[0])),
        DataCell(Text(order.status)),
      ] );
    }).toList()
    ))
    );
  }
}
