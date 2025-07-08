import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:menu_bar/model/warehouse.dart';

class WarehouseService {
  final String baseUrl = 'http://192.168.0.104:8080/war'; // replace with your backend API

  // Get all warehouse records
  Future<List<Warehouse>> getAllWarehouses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Warehouse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load warehouses');
    }
  }

  // Add new warehouse record
  Future<void> addWarehouse(Warehouse warehouse) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add warehouse');
    }
  }

  // Update existing warehouse record
  Future<void> updateWarehouse(Warehouse warehouse) async {
    if (warehouse.warehouseId == null) {
      throw Exception('Warehouse ID is required to update');
    }
    final url = '$baseUrl/${warehouse.warehouseId}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update warehouse');
    }
  }

  // Delete warehouse record by id
  Future<void> deleteWarehouse(int warehouseId) async {
    final url = '$baseUrl/$warehouseId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete warehouse');
    }
  }
}
