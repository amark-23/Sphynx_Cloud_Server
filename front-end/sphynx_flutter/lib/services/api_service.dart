import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/file_item.dart';

class ApiService {
  final String baseUrl = "http://192.168.2.5:5000";

  /// Fetch list of files and folders
  Future<List<FileItem>> getFiles({String folder = ''}) async {
    final response = await http.get(Uri.parse('$baseUrl/files?folder=$folder'));

    if (response.statusCode == 200) {
      final List<dynamic> items = jsonDecode(response.body)['items'];
      return items.map((item) => FileItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load files.');
    }
  }

  /// Delete a file
  Future<bool> deleteFile(String filePath) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$filePath'));
    return response.statusCode == 200;
  }
}
