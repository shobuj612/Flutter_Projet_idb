import 'order.dart';

class Merchandising {
  int? merchId;
  Order order;
  String merchandiserName;
  String samplingDone;
  DateTime approvalDate;
  String remarks;

  Merchandising({
    this.merchId,
    required this.order,
    required this.merchandiserName,
    required this.samplingDone,
    required this.approvalDate,
    required this.remarks,
  });

  factory Merchandising.fromJson(Map<String, dynamic> json) {
    return Merchandising(
      merchId: json['merch_id'],
      order: Order.fromJson(json['order']),
      merchandiserName: json['merchandiser_name'],
      samplingDone: json['sampling_done'],
      approvalDate: DateTime.parse(json['approval_date']),
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merch_id': merchId,
      'order': {
        'order_id': order.orderId, // Only sending ID to backend
      },
      'merchandiser_name': merchandiserName,
      'sampling_done': samplingDone,
      'approval_date': approvalDate.toIso8601String(),
      'remarks': remarks,
    };
  }
}
