import 'order.dart';

class Sewing {
  int? sewingId;
  Order order;
  DateTime sewingStartDate;
  DateTime sewingEndDate;
  int sewingQty;

  Sewing({
    this.sewingId,
    required this.order,
    required this.sewingStartDate,
    required this.sewingEndDate,
    required this.sewingQty,
  });

  factory Sewing.fromJson(Map<String, dynamic> json) {
    return Sewing(
      sewingId: json['sewing_id'],
      order: Order.fromJson(json['order']),
      sewingStartDate: DateTime.parse(json['sewing_start_date']),
      sewingEndDate: DateTime.parse(json['sewing_end_date']),
      sewingQty: json['sewing_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sewing_id': sewingId,
      'order': {
        'order_id': order.orderId,
      },
      'sewing_start_date': sewingStartDate.toIso8601String(),
      'sewing_end_date': sewingEndDate.toIso8601String(),
      'sewing_qty': sewingQty,
    };
  }
}
