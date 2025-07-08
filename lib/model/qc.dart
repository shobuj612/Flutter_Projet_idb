import 'package:menu_bar/model/order.dart';

class QC {
  int? qcId;
  Order order;
  DateTime inspectionDate;
  int passedQty;
  int rejectedQty;
  String remarks;

  QC({
    this.qcId,
    required this.order,
    required this.inspectionDate,
    required this.passedQty,
    required this.rejectedQty,
    required this.remarks,
  });

  factory QC.fromJson(Map<String, dynamic> json) {
    return QC(
      qcId: json['qc_id'],
      order: Order.fromJson(json['order']),
      inspectionDate: DateTime.parse(json['inspection_date']),
      passedQty: json['passed_qty'],
      rejectedQty: json['rejected_qty'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qc_id': qcId,
      'order': {
        'order_id': order.orderId,
      },
      'inspection_date': inspectionDate.toIso8601String(),
      'passed_qty': passedQty,
      'rejected_qty': rejectedQty,
      'remarks': remarks,
    };
  }
}
