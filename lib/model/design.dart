import 'package:menu_bar/model/order.dart';

class Design{
  int? designId;
  Order order;
  String designName;
  String designImageUrl;
  String status;
  String remarks;
  Design({
    this.designId,
    required this.order,
    required this.designName,
    required this.designImageUrl,
    required this.status,
    required this.remarks
  });
  factory Design.fromJson(Map<String,dynamic> json){
    return Design(
      designId: json['design_id'],
      order: Order.fromJson(json['order']),
      designName: json['design_name'],
      designImageUrl: json['design_image_url'], 
      status: json['status'],
      remarks: json['remarks']
    );
  }
  Map<String,dynamic> toJson(){
    return{
     'design_id':designId,
     'order':{
      'order_id':order.orderId
     },
     'design_name':designName,
     'design_image_url':designImageUrl,
     'status':status,
     'remarks':remarks
    };
  }

}


/*

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "design_id")
    private Long design_id;
    
    
    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @Column(name = "design_name", nullable = false)
    private String design_name;

    @Column(name = "design_image_url")
    private String design_image_url;

    @Column(name = "status")
    private String status;

    @Column(name = "remarks")
    private String remarks;

    public DesignInfo() {}
 */