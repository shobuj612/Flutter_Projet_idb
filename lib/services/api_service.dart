import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:menu_bar/model/buyer.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080'; // Localhost for Android emulator

  // GET all buyers
  Future<List<Buyer>> getAllBuyers() async {
    final response = await http.get(Uri.parse('$baseUrl/buyer'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Buyer.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load buyers");
    }
  }

  // POST - add new buyer
  Future<void> addBuyer(Buyer buyer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(buyer.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add buyer');
    }
  }

  // PUT - update buyer
  Future<void> updateBuyer(Buyer buyer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/buyer/${buyer.buyerId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(buyer.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update buyer');
    }
  }

  // DELETE buyer
  Future<void> deleteBuyer(int buyerId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/buyer/$buyerId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete buyer');
    }
  }
}
