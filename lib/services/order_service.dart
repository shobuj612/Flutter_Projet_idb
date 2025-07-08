import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menu_bar/model/order.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.0.104:8080/orders';

  // Get all orders
  Future<List<Order>> getAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) {
      throw Exception("No token found");
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load orders");
    }
  }

  // Add new order
  Future<void> addOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) {
      throw Exception("No token found");
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add order");
    }
  }

  // Update order
  Future<void> updateOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) {
      throw Exception("No token found");
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${order.orderId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update order");
    }
  }

  // Delete order
  Future<void> deleteOrder(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) {
      throw Exception("No token found");
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete order");
    }
  }
 // import 'dart:io';
//import 'package:path_provider/path_provider.dart';
//import 'package:open_file/open_file.dart';

Future<void> downloadOrderReport() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt-token');

  if (token == null) {
    throw Exception("No token found");
  }

  final response = await http.get(
    Uri.parse('http://192.168.0.104:8080/api/report/order'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/order_report.pdf';
    final file = File(filePath);

    await file.writeAsBytes(bytes);
    await OpenFile.open(filePath); // this opens the PDF
  } else {
    throw Exception("Failed to download order report");
  }
}

}
