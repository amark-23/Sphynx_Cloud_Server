import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerStatsService {
  final String baseUrl = "http://192.168.2.5:5000";

  Future<Map<String, dynamic>?> fetchServerStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/server-stats'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to load server stats: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching server stats: $e");
      return null;
    }
  }
}
