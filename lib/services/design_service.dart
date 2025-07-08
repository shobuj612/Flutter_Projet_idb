import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:menu_bar/model/design.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignService {
  static const String baseUrl = 'http://192.168.0.104:8080/design';

  Future<List<Design>> getAllDesigns() async {
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
      return data.map((json) => Design.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load designs");
    }
  }

  Future<void> addDesign(Design design) async {
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
      body: jsonEncode(design.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add design");
    }
  }

  Future<void> updateDesign(Design design) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/${design.designId}'),
      headers: headers,
      body: jsonEncode(design.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update design");
    }
  }

  Future<void> deleteDesign(int id) async {
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
      throw Exception("Failed to delete design");
    }
  }

  Future<void> downloadDesignReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception("No token found");

    final headers = {
      'Authorization': 'Bearer $token',
    };

    const url = 'http://192.168.0.104:8080/api/report/design';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/DesignReport.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download design report");
    }
  }
}
