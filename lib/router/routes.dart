import 'package:flutter/material.dart';
import 'package:menu_bar/screens/admin/attendence_list.dart';
import 'package:menu_bar/screens/admin/order_list.dart';
import 'package:menu_bar/screens/admin/production_dashboard.dart';
import 'package:menu_bar/screens/cutting/add_cutting.dart';
import 'package:menu_bar/screens/cutting/cutting_lilst.dart';
import 'package:menu_bar/screens/design/add_design.dart';
import 'package:menu_bar/screens/design/design_list.dart';
import 'package:menu_bar/screens/fabric/add_fabric.dart';
import 'package:menu_bar/screens/fabric/fabric_list.dart';
import 'package:menu_bar/screens/finishing/add_finishing.dart';
import 'package:menu_bar/screens/finishing/finishing_list.dart';
import 'package:menu_bar/screens/hrscreen/employee_attendence_list.dart';
import 'package:menu_bar/screens/hrscreen/employee_payment.dart';
import 'package:menu_bar/screens/hrscreen/employee_registration.dart';
import 'package:menu_bar/screens/marchendising/add_buyer.dart';
import 'package:menu_bar/screens/marchendising/add_order.dart';
import 'package:menu_bar/screens/marchendising/dashboard.dart';
import 'package:menu_bar/screens/marchendising/jop_post.dart';
import 'package:menu_bar/screens/marchendising/order_list.dart';
import 'package:menu_bar/screens/marchendising/buyer_list.dart';
import 'package:menu_bar/screens/home_screen.dart';
import 'package:menu_bar/screens/login.dart';
import 'package:menu_bar/screens/qc/add_qc.dart';
import 'package:menu_bar/screens/qc/qc_list.dart';
import 'package:menu_bar/screens/sewing/add_sewing.dart';
import 'package:menu_bar/screens/sewing/sewing_list.dart';
import 'package:menu_bar/screens/shipping/add_shipping.dart';
import 'package:menu_bar/screens/shipping/shipping_list.dart';
import 'package:menu_bar/screens/warehouse/add_warehouse.dart';
import 'package:menu_bar/screens/warehouse/warehouse_list.dart';

final routes=<String,WidgetBuilder>{
'/':(context)=>HomeScreen(),
'/login':(context)=>const LoginScreen(),
// this is for admin
'/attendencelist':(context)=>const AttendenceListScreen(),
'/orderlist':(context)=>const OrderListScreenByAdmin(),
'/production':(context)=>const ProductionDashboard(),
// this is for cutting
'/addcutting':(context)=>const AddCuttingScreen(),
'/cuttinglist':(context)=>const CuttingListScreen(),
// this is for design
'/adddesign':(context)=> const AddDesignScreen(),
'/designlist':(context)=>const DesignListScreen(),
// this is for fabric
'/addfabric':(context)=>const AddFabricScreen(),
'/fabriclist':(context)=> const FabricListScreen(),
// this is for finishing
'/addfinishing':(context)=>const AddFinishingScreen(),
'/finishinglist':(context)=>const FinishingListScreen(),
// this is for hrscreen
'/employeeattendence':(context)=>const EmployeeAttendenceListScreen(),
'/employeepayment':(context)=>const EmployeePaymentScreen(),
'/employeeregis':(context)=>const EmployeeRegistrationScreen(),
// this is for marchendising
'/addorder':(context)=>const AddOrderScreen(),
'/marchorderlist':(context)=>const OrderListScreen(),
'/ab':(context)=>const AddBuyerScreen(),
'/bl':(context)=>const BuyerListScreen(),
'/dahsboard':(context)=>const MarchDashboardScreen(),
'/jobpost':(context)=>const JobPostScreen(),
// this is fro qc
'/addqc':(context)=>const AddQcScreen(),
'/qclist':(context)=>const QcListScreen(),
// this is for sewing
'/addsewing':(context)=>const AddSewingScreen(),
'/sewinglist':(context)=>const SewingListScreen(),
// this is for shipping
'/addshipping':(context)=>const AddShippingScreen(),
'/shippinglist':(context)=>const ShippingListScreen(),
// this is for warehouse
'/addwarehouse':(context)=>const AddWarehouseScreen(),
'/warehouselist':(context)=>const WarehouseListScreen()


};
/**
 * MARCH: 'ROLE_MARCH',
    DESIGN: 'ROLE_DESIGN',
    FABRIC: 'ROLE_FABRIC',
    CUTTING: 'ROLE_CUTTING',
    SEWING: 'ROLE_SEWING',
    FINISHING: 'ROLE_FINISHING',
    QC: 'ROLE_QC',
    WAREHOUSE: 'ROLE_WAREHOUSE',
    SHIPPING: 'ROLE_SHIPPING',
    ADMIN:'ROLE_ADMIN',
    HR:'ROLE_HR'
 */