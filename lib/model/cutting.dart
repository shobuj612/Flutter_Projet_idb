import 'package:menu_bar/model/order.dart';

class Cutting {
  int? cuttingId;
  Order order;
  DateTime cuttingStartDate;
  DateTime cuttingEndDate;
  int cuttingQty;
  String supervisorName;

  Cutting({
    this.cuttingId,
    required this.order,
    required this.cuttingStartDate,
    required this.cuttingEndDate,
    required this.cuttingQty,
    required this.supervisorName,
  });

  factory Cutting.fromJson(Map<String, dynamic> json) {
    return Cutting(
      cuttingId: json['cutting_id'],
      order: Order.fromJson(json['order']),
      cuttingStartDate: DateTime.parse(json['cutting_start_date']),
      cuttingEndDate: DateTime.parse(json['cutting_end_date']),
      cuttingQty: json['cut_qty'],
      supervisorName: json['supervisor_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cutting_id': cuttingId,
      'order': {
        'order_id': order.orderId
      },
      'cutting_start_date': cuttingStartDate.toIso8601String(),
      'cutting_end_date': cuttingEndDate.toIso8601String(),
      'cut_qty': cuttingQty,
      'supervisor_name': supervisorName
    };
  }
}




/*
@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cutting_id")
    private Long cutting_id;

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;


    @Column(name = "cutting_start_date")
    @Temporal(TemporalType.DATE)
    private Date cutting_start_date;

    @Column(name = "cutting_end_date")
    @Temporal(TemporalType.DATE)
    private Date cutting_end_date;

    @Column(name = "cut_qty")
    private int cut_qty;

    @Column(name = "supervisor_name")
    private String supervisor_name;

    // Default constructor
    public Cutting() {}

*/