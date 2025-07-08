import 'order.dart';

class Warehouse {
  int? warehouseId;
  Order order;
  DateTime receivedDate;
  int storedQty;

  Warehouse({
    this.warehouseId,
    required this.order,
    required this.receivedDate,
    required this.storedQty,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      warehouseId: json['warehouse_id'],
      order: Order.fromJson(json['order']),
      receivedDate: DateTime.parse(json['received_date']),
      storedQty: json['stored_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_id': warehouseId,
      'order': {
        'order_id': order.orderId, // ✅ only sending order ID
      },
      'received_date': receivedDate.toIso8601String(),
      'stored_qty': storedQty,
    };
  }
}
