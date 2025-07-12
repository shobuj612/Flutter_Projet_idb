import 'package:flutter/material.dart';
import 'package:menu_bar/model/order.dart';
import 'package:menu_bar/services/order_service.dart';

class OrderInformationInDesign extends StatefulWidget{
  const OrderInformationInDesign({super.key});
  @override
  OrderInformationInDesignScreenState createState()=> OrderInformationInDesignScreenState();
}
// this is another class
 class OrderInformationInDesignScreenState extends State<OrderInformationInDesign>{
  List<Order> orders=[];
  bool isloading=true;
   final OrderService  _orderService=OrderService();// this is object
   @override
   void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async{
    try{
      final data = await _orderService.getAllOrders();
      if(!mounted) return;
      setState((){
        orders=data;
        isloading=false;
      });
    }
    catch(e){
      if(!mounted) return;
      debugPrint('not found the data:$e');
      setState(() {
        isloading=false;
      });
    }
  }
  // this is the method to make the ui
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Information'),
        backgroundColor: Colors.cyan
      ),
      body:isloading?
      const Center(child: CircularProgressIndicator()):
       SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Order Id')),
            DataColumn(label: Text('Order Name')),
            DataColumn(label: Text('Buyer Name')),
            DataColumn(label: Text('StyleNo')),
            DataColumn(label: Text('Order Qty')),
            DataColumn(label: Text('OrderDate')),
            DataColumn(label: Text('DeliveryDate')),
            DataColumn(label: Text('status')),
          ],
          rows:orders.map((order){
            return DataRow(
              cells:[
                 DataCell(Text(order.orderId.toString())),
                DataCell(Text(order.orderName)),
                DataCell(Text(order.buyer.buyerName)),
                DataCell(Text(order.styleNo)),
                DataCell(Text(order.orderQty.toString())),
                DataCell(Text(order.orderDate.toLocal().toString().split(' ')[0])),
                DataCell(Text(order.deliveryDate.toLocal().toString().split(' ')[0])),
                DataCell(Text(order.status))
              ]
            
            );
          }).toList()
          ),
      )
    );
  }

 }