import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:menu_bar/model/warehouse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseService {
  final String baseUrl =
      'http://192.168.0.104:8080/war'; // replace with your backend API

  // Get all warehouse records
  Future<List<Warehouse>> getAllWarehouses() async {
    final myToken = await SharedPreferences
        .getInstance(); //this is to make the way to inter the disk where the token is saved
    final token = myToken
        .getString('jwt-token'); // this is to collect the token from the disk
    if (token == null) {
      throw Exception('token not found');
    }
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Warehouse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load warehouses');
    }
  }

  // Add new warehouse record
  Future<void> addWarehouse(Warehouse warehouse) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    if (token == null) {
      throw Exception('no token found');
    }
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add warehouse');
    }
  }

  // Update existing warehouse record
  Future<void> updateWarehouse(Warehouse warehouse) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    if (token == null) {
      throw Exception('token not found');
    }
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    if (warehouse.warehouseId == null) {
      throw Exception('Warehouse ID is required to update');
    }
    final url = '$baseUrl/${warehouse.warehouseId}';
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(warehouse.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update warehouse');
    }
  }

  // Delete warehouse record by id
  Future<void> deleteWarehouse(int warehouseId) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    if (token == null) {
      throw Exception('token not found');
    }
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final url = '$baseUrl/$warehouseId';
    final response = await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete warehouse');
    }
  }
}
