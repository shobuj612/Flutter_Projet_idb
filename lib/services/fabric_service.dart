import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:menu_bar/model/fabric.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FabricService {
  static const String baseUrl = 'http://192.168.0.104:8080/fabric';

  Future<List<Fabric>> getAllFabrics() async {
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
      return data.map((json) => Fabric.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load fabrics");
    }
  }

  Future<void> addFabric(Fabric fabric) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(fabric.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add fabric");
    }
  }

  Future<void> updateFabric(Fabric fabric) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/${fabric.fabricId}'),
      headers: headers,
      body: jsonEncode(fabric.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update fabric");
    }
  }

  Future<void> deleteFabric(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete fabric");
    }
  }

  Future<void> downloadFabricReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception("No token found");

    final headers = {
      'Authorization': 'Bearer $token',
    };

    const url = 'http://192.168.0.104:8080/api/report/fabric';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/FabricReport.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download fabric report");
    }
  }
}
