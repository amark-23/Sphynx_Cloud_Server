import 'dart:convert';
import 'package:http/http.dart' as http;

class PreviewService {
  final String baseUrl = "http://192.168.2.5:5000";

  Future<Map<String, dynamic>> previewFile(String filePath) async {
    final response = await http.get(Uri.parse('$baseUrl/preview/$filePath'));

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'] ?? '';

      if (contentType.startsWith('image')) {
        // Image preview
        return {"type": "image", "url": "$baseUrl/preview/$filePath"};
      } else if (contentType.contains('application/json')) {
        // Text preview
        final jsonData = jsonDecode(response.body);
        return {
          "type": "text",
          "content": jsonData['content'] ?? 'No content available',
        };
      } else {
        return {
          "type": "unsupported",
          "message": "Preview not available for this file type",
        };
      }
    } else {
      throw Exception('Failed to load preview.');
    }
  }
}
