import 'package:menu_bar/model/order.dart';

class Finishing {
  int? finishId;
  Order order;
  DateTime finishingDate;
  int finishQty;
  String packingDone;

  Finishing({
    this.finishId,
    required this.order,
    required this.finishingDate,
    required this.finishQty,
    required this.packingDone,
  });

  // Factory to create a Finishing object from JSON
  factory Finishing.fromJson(Map<String, dynamic> json) {
    return Finishing(
      finishId: json['finish_id'],
      order: Order.fromJson(json['order']),
      finishingDate: DateTime.parse(json['finishing_date']),
      finishQty: json['finish_qty'],
      packingDone: json['packing_done'],
    );
  }

  // Method to convert Finishing object to JSON
  Map<String, dynamic> toJson() {
    return {
      'finish_id': finishId,
      'order': {
        'order_id': order.orderId, // ✅ sending only ID
      },
      'finishing_date': finishingDate.toIso8601String(),
      'finish_qty': finishQty,
      'packing_done': packingDone,
    };
  }
}
