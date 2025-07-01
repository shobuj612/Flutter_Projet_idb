import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final bool isLoggIn = true;
  final List<String> userRoles = ['ROLE_ADMIN', 'ROLE_MARCH'];

  HomeScreen({super.key}); // Constructor with optional key

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
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (isLoggIn)
            TextButton(
              onPressed: () => print("Logout clicked"),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
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
                child: Text(
                  "Sidebar Menu",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(color: Colors.blue),
              ),

              // Admin Panel
              if (userRoles.contains('ROLE_ADMIN'))
                buildExpansionTile(context, "Admin", [
                  buildNavItem(context, "Dashboard", '/dash'),
                ]),

              // Merchandising Panel
              if (userRoles.contains('ROLE_MARCH'))
                buildExpansionTile(context, "Marchendising", [
                  buildNavItem(context, "Buyer List", '/bl'),
                  buildNavItem(context, "Add Buyer", '/ab'),
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

  // Widget method to build expandable menu
  Widget buildExpansionTile(
      BuildContext ctx, String title, List<Widget> items) {
    return Theme(
      data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        children: items,
      ),
    );
  }

  // Widget method to build each navigation item
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
//Moved buildExpansionTile() and buildNavItem() outside build() (they can't be nested inside build())
// add super.key to call the parent class constructor
