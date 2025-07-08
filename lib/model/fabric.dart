import 'package:menu_bar/model/order.dart';

class Fabric{
int? fabricId;
Order order;
String fabricType;
int fabricQty;
DateTime receivedDate;
int availableStock;
Fabric(
  {
  this.fabricId,
  required this.order,
  required this.fabricType,
  required this.fabricQty,
  required this.receivedDate,
  required this.availableStock
  
  }
);
factory Fabric.fromJson(Map<String,dynamic> json){
  return Fabric (
    fabricId: json ['fabric_id'],
    order:  Order.fromJson(json['order']) ,
    fabricType: json ['fabric_type'],
    fabricQty: json ['fabric_qty'],
    receivedDate: DateTime.parse(json['received_date']),
    availableStock: json['available_stock']
  );
}
Map<String,dynamic> toJson(){
  return{
    'fabric_id':fabricId,
    'order':{
      'order_id':order.orderId
    },
    'fabric_type':fabricType,
    'fabric_qty':fabricQty,
    'received_date':receivedDate.toIso8601String(),
    'available_stock':availableStock
  };
}
}


/*
 @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fabric_id")
    private Long fabric_id;
    
    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @Column(name = "fabric_type", nullable = false)
    private String fabric_type;

    @Column(name = "fabric_qty")
    private int fabric_qty;

    @Column(name = "received_date")
    @Temporal(TemporalType.DATE)
    private Date received_date;

    @Column(name = "available_stock")
    private int available_stock;

 */