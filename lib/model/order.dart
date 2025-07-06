import 'package:menu_bar/model/buyer.dart';

class Order {
  int? orderId;
  Buyer buyer;
  String orderName;
  String styleNo;
  int orderQty;
  DateTime orderDate;
  DateTime deliveryDate;
  String status;

// this is the objet 
  Order({
  this.orderId,
  required this.buyer,
  required this.orderName,
  required this.styleNo,
  required this.orderQty,
  required this.orderDate,
  required this.deliveryDate,
  required this.status
});

// this is the factory object
factory Order.fromJson(Map<String,dynamic> json){
  return Order(
    orderId: json['order_id'],
    buyer:Buyer.fromJson(json['buyer']),
    orderName: json['order_name'],
    styleNo: json['style_no'],
    orderQty: json['order_qty'],
    orderDate: DateTime.parse(json['order_date']),
    deliveryDate: DateTime.parse(json['delivery_date']),
    status: json['status']
  );
}

// this is the method to covert the object to the json
Map<String,dynamic> toJson(){
  return{
        'order_id':orderId,
        'buyer':{
          'buyer_id':buyer.buyerId
        },
        'order_name':orderName,
        'style_no':styleNo,
        'order_qty':orderQty,
        'order_date':orderDate.toIso8601String(),
        'delivery_date':deliveryDate.toIso8601String(),
        'status':status
  };
}
}





/*
 @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private Long order_id;

    // Many orders can belong to one buyer
    @ManyToOne
    @JoinColumn(name = "buyer_id", nullable = false)
    private Buyer buyer;
    
    @Column(name="order_name",nullable=false)
    private String order_name;

    @Column(name = "style_no")
    private String style_no;

    @Column(name = "order_qty")
    private int order_qty;

    @Column(name = "order_date")
    @Temporal(TemporalType.DATE)
    private Date order_date;

    @Column(name = "delivery_date")
    @Temporal(TemporalType.DATE)
    private Date delivery_date;

    @Column(name = "status")
    private String status;
*/
 