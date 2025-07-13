import 'package:flutter/material.dart';
import 'package:menu_bar/model/warehouse.dart';
import 'package:menu_bar/screens/warehouse/add_warehouse.dart';
import 'package:menu_bar/services/warehouse_service.dart';

class WarehouseListScreen extends StatefulWidget {
  const WarehouseListScreen({super.key});

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  List<Warehouse> warehouseList = [];
  final WarehouseService _warehouseService = WarehouseService();

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
  }

  Future<void> fetchWarehouses() async {
    try {
      final data = await _warehouseService.getAllWarehouses();
      if (!mounted) return;
      setState(() {
        warehouseList = data;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint("Failed to fetch warehouses: $e");
    }
  }

  Future<void> deleteWarehouse(int id) async {
    try {
      await _warehouseService.deleteWarehouse(id);
      if (!mounted) return;
      fetchWarehouses();
    } catch (e) {
      if (!mounted) return;
      debugPrint("Failed to delete warehouse: $e");
    }
  }

  void editWarehouse(Warehouse warehouse) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWarehouseScreen(warehouse: warehouse),
      ),
    );
    if (!mounted) return;
    fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse List")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: warehouseList.isEmpty
            ? const Center(child: Text("No data available"))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Warehouse ID")),
                    DataColumn(label: Text("Order Id")),
                    DataColumn(label: Text("Order Name")),// this is new added
                    DataColumn(label: Text("Order StyleNo")),// this is new added
                    DataColumn(label: Text("Received Date")),
                    DataColumn(label: Text("Stored Qty")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: warehouseList.map((w) {
                    return DataRow(cells: [
                      DataCell(Text(w.warehouseId?.toString() ?? '')),
                      DataCell(Text(w.order.orderId?.toString() ?? '')),
                      DataCell(Text(w.order.orderName)),
                      DataCell(Text(w.order.styleNo)),
                      DataCell(Text(w.receivedDate.toString().split("T")[0])),
                      DataCell(Text(w.storedQty.toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => editWarehouse(w),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (w.warehouseId != null) {
                                deleteWarehouse(w.warehouseId!);
                              }
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddWarehouseScreen(),
            ),
          );
          if (!mounted) return;
          fetchWarehouses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
