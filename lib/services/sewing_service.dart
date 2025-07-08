import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:menu_bar/model/sewing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SewingService {
  static const String baseUrl = 'http://192.168.0.104:8080/sew';

  Future<List<Sewing>> getAllSewingRecords() async {
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
      return data.map((json) => Sewing.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load sewing records");
    }
  }

  Future<void> addSewing(Sewing sewing) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sewing.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add sewing record");
    }
  }

  Future<void> updateSewing(Sewing sewing) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/${sewing.sewingId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(sewing.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update sewing record");
    }
  }

  Future<void> deleteSewing(int id) async {
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
      throw Exception("Failed to delete sewing record");
    }
  }

  Future<void> downloadSewingReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');
    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse('http://192.168.0.104:8080/api/report/sew'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/SewingReport.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download sewing report");
    }
  }
}
