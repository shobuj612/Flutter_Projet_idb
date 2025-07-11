import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // Check if token is saved in SharedPreferences
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt-token');

    if (!mounted) return; // ✅ this prevents using setState on disposed widget

    setState(() {
      isLoggIn = token != null;
    });
  }

  // Optional: Logout
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt-token');

    if (!mounted) return; // ✅ check before using context or setState

    setState(() {
      isLoggIn = false;
      // this to when the logout
      // Navigator.pushNamed(context, '/login');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garment Management'),
        backgroundColor: const Color(0xFF0dabdf),
        actions: [
          if (!isLoggIn)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login').then((_) {
                checkLoginStatus(); // 🔄 re-check token after coming back
              }),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          if (isLoggIn)
            TextButton(
              onPressed: logout,
              child:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer:isLoggIn?
       Drawer(
        child: Container(
          color: const Color(0xFF0dabdf),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child:
                    Text("Sidebar Menu", style: TextStyle(color: Colors.white)),
              ),
              //buildExpansionTile(context, 'Admin', [
              //buildNavItem(context, "Attendance List", '/attendencelist'),
              //buildNavItem(context, "Order List", '/orderlist'),
              //buildNavItem(context, "Production Dashboard", '/production'),
              // ]), this is now stopped for the project
              // this is for marchendising

              buildExpansionTile(context, 'Marchendising', [
                // buildNavItem(context, "Dashboard", '/dahsboard'),
                buildNavItem(context, "Add Buyer", '/ab'),
                buildNavItem(context, "Buyer List", '/bl'),
                buildNavItem(context, "Add Order", '/addorder'),
                buildNavItem(context, "Order List", '/marchorderlist'),
                //buildNavItem(context, "Job Post", '/jobpost'),
              ]),
              // this is for Design

              buildExpansionTile(context, 'Design', [
                buildNavItem(context, "Add Design", '/adddesign'),
                buildNavItem(context, "Design List", '/designlist'),
                buildNavItem(context, "Order Information", '/orderindesign'),
              ]),

              // this is for fabric
              buildExpansionTile(context, 'Fabric', [
                buildNavItem(context, "Add Fabric", '/addfabric'),
                buildNavItem(context, "Fabric List", '/fabriclist'),
                // buildNavItem(context, "Fabric List", '/fabriclist'),
                buildNavItem(context, "Order Information", '/orderinfabric'),
              ]),
              // this is for cutting
              buildExpansionTile(context, 'Cutting', [
                buildNavItem(context, "Add Cutting", '/addcutting'),
                buildNavItem(context, "Cutting List", '/cuttinglist'),
                buildNavItem(context, "Order Information", '/orderincutting'),
              ]),

              // this is for sewing
              buildExpansionTile(context, 'Sewing', [
                buildNavItem(context, "Add Sewing", '/addsewing'),
                buildNavItem(context, "Sewing List", '/sewinglist'),
                buildNavItem(context, "Order Information", '/orderinsew'),
              ]),
              // this is for finishing
              buildExpansionTile(context, 'Finishing', [
                buildNavItem(context, "Add Finishing", '/addfinishing'),
                buildNavItem(context, "Finishing List", '/finishinglist'),
                buildNavItem(context, "Order Information", '/orderinfinishing'),
              ]),
              // this is quality control
              buildExpansionTile(context, 'Quality Control', [
                buildNavItem(context, "Add QC", '/addqc'),
                buildNavItem(context, "QC List", '/qclist'),
                buildNavItem(context, "Order Information", '/orderinqc'),
              ]),
              // this is for warehouse
              buildExpansionTile(context, 'Warehouse', [
                buildNavItem(context, "Add Warehouse", '/addwarehouse'),
                buildNavItem(context, "Warehouse List", '/warehouselist'),
                buildNavItem(context, "Order Information", '/orderinwarehouse'),
              ]),
              // this is for shipping
              buildExpansionTile(context, 'Shipping', [
                buildNavItem(context, "Add Shipping", '/addshipping'),
                buildNavItem(context, "Shipping List", '/shippinglist'),
                buildNavItem(context, "Order Information", '/orderinship'),
              ]),
              //buildExpansionTile(context, 'HR', [
              // buildNavItem(
              //    context, "Employee Attendance", '/employeeattendence'),
              //  buildNavItem(context, "Employee Payment", '/employeepayment'),
              //  buildNavItem(
              // context, "Employee Registration", '/employeeregis'),
              //]),
            ],
          ),
        ),
      )
      :null,
      body: const Center(
        child: Text("Welcome to the Garment Company"),
      ),
    );
  }

  Widget buildExpansionTile(
      BuildContext ctx, String title, List<Widget> items) {
    return Theme(
      data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: items,
      ),
    );
  }

  Widget buildNavItem(BuildContext ctx, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
//this is for taking the login information
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // or your key
    setState(() {
      isLoggIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garment Management'),
        backgroundColor: const Color(0xFF0dabdf),
        actions: [
          if (!isLoggIn)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          if (isLoggIn)
            TextButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('token');
                  setState(() {
                    isLoggIn = false;
                  });
                });
              },
              child:
                  const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0dabdf),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child:
                    Text("Sidebar Menu", style: TextStyle(color: Colors.white)),
              ),
              buildExpansionTile(context, 'Admin', [
                buildNavItem(context, "Attendance List", '/attendencelist'),
                buildNavItem(context, "Order List", '/orderlist'),
                buildNavItem(context, "Production Dashboard", '/production'),
              ]),
              // ... rest of your menu
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text("Welcome to the Garment Company"),
      ),
    );
  }

  Widget buildExpansionTile(
      BuildContext ctx, String title, List<Widget> items) {
    return Theme(
      data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: items,
      ),
    );
  }

  Widget buildNavItem(BuildContext ctx, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}

*/

/*

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
//this is for taking the login information
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // or your key
    setState(() {
      isLoggIn = token != null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garment Management'),
        backgroundColor: const Color(0xFF0dabdf),
        actions: [
          if (!isLoggIn)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          if (isLoggIn)
            TextButton(
              onPressed: () => print("Logout clicked"),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0dabdf),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("Sidebar Menu", style: TextStyle(color: Colors.white)),
              ),

              buildExpansionTile(context, 'Admin', [
                buildNavItem(context, "Attendance List", '/attendencelist'),
                buildNavItem(context, "Order List", '/orderlist'),
                buildNavItem(context, "Production Dashboard", '/production'),
              ]),

              buildExpansionTile(context, 'Marchendising', [
                buildNavItem(context, "Dashboard", '/dahsboard'),
                buildNavItem(context, "Add Buyer", '/ab'),
                buildNavItem(context, "Buyer List", '/bl'),
                buildNavItem(context, "Add Order", '/addorder'),
                buildNavItem(context, "Order List", '/marchorderlist'),
                buildNavItem(context, "Job Post", '/jobpost'),
              ]),

              buildExpansionTile(context, 'Design', [
                buildNavItem(context, "Add Design", '/adddesign'),
                buildNavItem(context, "Design List", '/designlist'),
              ]),

              buildExpansionTile(context, 'Fabric', [
                buildNavItem(context, "Add Fabric", '/addfabric'),
                buildNavItem(context, "Fabric List", '/fabriclist'),
              ]),

              buildExpansionTile(context, 'Cutting', [
                buildNavItem(context, "Add Cutting", '/addcutting'),
                buildNavItem(context, "Cutting List", '/cuttinglist'),
              ]),

              buildExpansionTile(context, 'Sewing', [
                buildNavItem(context, "Add Sewing", '/addsewing'),
                buildNavItem(context, "Sewing List", '/sewinglist'),
              ]),

              buildExpansionTile(context, 'Finishing', [
                buildNavItem(context, "Add Finishing", '/addfinishing'),
                buildNavItem(context, "Finishing List", '/finishinglist'),
              ]),

              buildExpansionTile(context, 'Quality Control', [
                buildNavItem(context, "Add QC", '/addqc'),
                buildNavItem(context, "QC List", '/qclist'),
              ]),

              buildExpansionTile(context, 'Warehouse', [
                buildNavItem(context, "Add Warehouse", '/addwarehouse'),
                buildNavItem(context, "Warehouse List", '/warehouselist'),
              ]),

              buildExpansionTile(context, 'Shipping', [
                buildNavItem(context, "Add Shipping", '/addshipping'),
                buildNavItem(context, "Shipping List", '/shippinglist'),
              ]),

              buildExpansionTile(context, 'HR', [
                buildNavItem(context, "Employee Attendance", '/employeeattendence'),
                buildNavItem(context, "Employee Payment", '/employeepayment'),
                buildNavItem(context, "Employee Registration", '/employeeregis'),
              ]),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text("Welcome to the Garment Company"),
      ),
    );
  }

  Widget buildExpansionTile(
      BuildContext ctx, String title, List<Widget> items) {
    return Theme(
      data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: items,
      ),
    );
  }

  Widget buildNavItem(BuildContext ctx, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}

*/
// this is role base access code
/*
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final bool isLoggIn = true;

  // These roles should come from backend token after login
  final List<String> userRoles = [
    'ROLE_ADMIN',
    'ROLE_MARCH',
    'ROLE_DESIGN',
    'ROLE_FABRIC',
    'ROLE_CUTTING',
    'ROLE_SEWING',
    'ROLE_FINISHING',
    'ROLE_QC',
    'ROLE_WAREHOUSE',
    'ROLE_SHIPPING',
    'ROLE_HR'
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garment Management'),
        backgroundColor: const Color(0xFF0dabdf),
        actions: [
          if (!isLoggIn)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          if (isLoggIn)
            TextButton(
              onPressed: () => print("Logout clicked"),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF0dabdf),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("Sidebar Menu", style: TextStyle(color: Colors.white)),
              ),

              // Admin
              if (userRoles.contains('ROLE_ADMIN'))
                buildExpansionTile(context, 'Admin', [
                  buildNavItem(context, "Attendance List", '/attendencelist'),
                  buildNavItem(context, "Order List", '/orderlist'),
                  buildNavItem(context, "Production Dashboard", '/production'),
                ]),

              // Marchendising
              if (userRoles.contains('ROLE_MARCH'))
                buildExpansionTile(context, 'Marchendising', [
                  buildNavItem(context, "Dashboard", '/dahsboard'),
                  buildNavItem(context, "Add Buyer", '/ab'),
                  buildNavItem(context, "Buyer List", '/bl'),
                  buildNavItem(context, "Add Order", '/addorder'),
                  buildNavItem(context, "Order List", '/marchorderlist'),
                  buildNavItem(context, "Job Post", '/jobpost'),
                ]),

              // Design
              if (userRoles.contains('ROLE_DESIGN'))
                buildExpansionTile(context, 'Design', [
                  buildNavItem(context, "Add Design", '/adddesign'),
                  buildNavItem(context, "Design List", '/designlist'),
                ]),

              // Fabric
              if (userRoles.contains('ROLE_FABRIC'))
                buildExpansionTile(context, 'Fabric', [
                  buildNavItem(context, "Add Fabric", '/addfabric'),
                  buildNavItem(context, "Fabric List", '/fabriclist'),
                ]),

              // Cutting
              if (userRoles.contains('ROLE_CUTTING'))
                buildExpansionTile(context, 'Cutting', [
                  buildNavItem(context, "Add Cutting", '/addcutting'),
                  buildNavItem(context, "Cutting List", '/cuttinglist'),
                ]),

              // Sewing
              if (userRoles.contains('ROLE_SEWING'))
                buildExpansionTile(context, 'Sewing', [
                  buildNavItem(context, "Add Sewing", '/addsewing'),
                  buildNavItem(context, "Sewing List", '/sewinglist'),
                ]),

              // Finishing
              if (userRoles.contains('ROLE_FINISHING'))
                buildExpansionTile(context, 'Finishing', [
                  buildNavItem(context, "Add Finishing", '/addfinishing'),
                  buildNavItem(context, "Finishing List", '/finishinglist'),
                ]),

              // QC
              if (userRoles.contains('ROLE_QC'))
                buildExpansionTile(context, 'Quality Control', [
                  buildNavItem(context, "Add QC", '/addqc'),
                  buildNavItem(context, "QC List", '/qclist'),
                ]),

              // Warehouse
              if (userRoles.contains('ROLE_WAREHOUSE'))
                buildExpansionTile(context, 'Warehouse', [
                  buildNavItem(context, "Add Warehouse", '/addwarehouse'),
                  buildNavItem(context, "Warehouse List", '/warehouselist'),
                ]),

              // Shipping
              if (userRoles.contains('ROLE_SHIPPING'))
                buildExpansionTile(context, 'Shipping', [
                  buildNavItem(context, "Add Shipping", '/addshipping'),
                  buildNavItem(context, "Shipping List", '/shippinglist'),
                ]),

              // HR
              if (userRoles.contains('ROLE_HR'))
                buildExpansionTile(context, 'HR', [
                  buildNavItem(context, "Employee Attendance", '/employeeattendence'),
                  buildNavItem(context, "Employee Payment", '/employeepayment'),
                  buildNavItem(context, "Employee Registration", '/employeeregis'),
                ]),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text("Welcome to the Garment Company"),
      ),
    );
  }

  Widget buildExpansionTile(
      BuildContext ctx, String title, List<Widget> items) {
    return Theme(
      data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: items,
      ),
    );
  }

  Widget buildNavItem(BuildContext ctx, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(ctx);
        Navigator.pushNamed(ctx, route);
      },
    );
  }
}

*/
 