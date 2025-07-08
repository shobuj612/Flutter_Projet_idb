import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:menu_bar/model/buyer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.0.104:8080/buyer'; // Localhost for Android emulator
  // get the token from the storage

  // GET all buyers
  Future<List<Buyer>> getAllBuyers() async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    if (token == null) {
      print('no token found');
      throw Exception('Unauthorized:no token found');
    }
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Buyer.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load buyers");
    }
  }

  // POST - add new buyer
  Future<void> addBuyer(Buyer buyer) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    if (token == null) {
      print('no token found');
      throw Exception('Unauthorized:no token found');
    }
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(buyer.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add buyer');
    }
  }

  // PUT - update buyer
  Future<void> updateBuyer(Buyer buyer) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    if (token == null) {
      print('no token found');
      throw Exception('Unauthorized:no token found');
    }
    final response = await http.put(
      Uri.parse('$baseUrl/${buyer.buyerId}'),
      headers: headers,
      body: jsonEncode(buyer.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update buyer');
    }
  }

  // DELETE buyer
  Future<void> deleteBuyer(int buyerId) async {
    final myToken = await SharedPreferences.getInstance();
    final token = myToken.getString('jwt-token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    if (token == null) {
      print('no token found');
      throw Exception('Unauthorized:no token found');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/$buyerId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete buyer');
    }
  }
  // this is the method to download the file

// 👇 Add this method inside your ApiService class
  Future<void> downloadBuyerReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) {
      throw Exception("No token found");
    }

    final headers = {
      'Authorization': 'Bearer $token',
    };

    const url = 'http://192.168.0.104:8080/api/report/buyer';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/BuyerReport.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // ✅ Open the file using default viewer
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download PDF report");
    }
  }
}
