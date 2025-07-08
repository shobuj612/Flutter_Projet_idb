import 'order.dart';

class Shipping {
  int? shippingId;
  Order order;
  DateTime shippingDate;
  int shippedQty;
  String invoiceNo;
  String destination;
  String carrier;

  Shipping({
    this.shippingId,
    required this.order,
    required this.shippingDate,
    required this.shippedQty,
    required this.invoiceNo,
    required this.destination,
    required this.carrier,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      shippingId: json['shipping_id'],
      order: Order.fromJson(json['order']),
      shippingDate: DateTime.parse(json['shipping_date']),
      shippedQty: json['shipped_qty'],
      invoiceNo: json['invoice_no'],
      destination: json['destination'],
      carrier: json['carrier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping_id': shippingId,
      'order': {
        'order_id': order.orderId,
      },
      'shipping_date': shippingDate.toIso8601String(),
      'shipped_qty': shippedQty,
      'invoice_no': invoiceNo,
      'destination': destination,
      'carrier': carrier,
    };
  }
}
