import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:menu_bar/model/shipping.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingService {
  static const String baseUrl = 'http://192.168.0.104:8080/ship';

  // GET all shipping records
  Future<List<Shipping>> getAllShippingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Shipping.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load shipping records");
    }
  }

  // POST - Add shipping
  Future<void> addShipping(Shipping shipping) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(shipping.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add shipping record");
    }
  }

  // PUT - Update shipping
  Future<void> updateShipping(Shipping shipping) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/${shipping.shippingId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(shipping.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update shipping record");
    }
  }

  // DELETE - Delete shipping
  Future<void> deleteShipping(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete shipping record");
    }
  }

  // DOWNLOAD shipping report
  Future<void> downloadShippingReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse('http://192.168.0.104:8080/api/report/ship'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ShippingReport.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download shipping report");
    }
  }
}
