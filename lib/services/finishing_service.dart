import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:menu_bar/model/finishing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishingService {
  static const String baseUrl = 'http://192.168.0.104:8080/finis';

  Future<List<Finishing>> getAllFinishing() async {
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
      return data.map((json) => Finishing.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load finishing records");
    }
  }

  Future<void> addFinishing(Finishing finishing) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(finishing.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add finishing");
    }
  }

  Future<void> updateFinishing(Finishing finishing) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception('Unauthorized: No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/${finishing.finishId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(finishing.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update finishing");
    }
  }

  Future<void> deleteFinishing(int id) async {
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
      throw Exception("Failed to delete finishing record");
    }
  }

  Future<void> downloadFinishingReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt-token');

    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse('http://192.168.0.104:8080/api/report/finish'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/FinishingReport.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } else {
      throw Exception("Failed to download finishing report");
    }
  }
}
