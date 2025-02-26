import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final String baseUrl = "http://192.168.2.5:5000";

  /// Download a file from the server
  Future<void> downloadFile(
    String filename,
    Function(double) onProgress,
  ) async {
    final url = Uri.parse('$baseUrl/download/$filename');

    try {
      // Get Downloads folder
      Directory? downloadsDir = await getDownloadsDirectory();
      String savePath = '${downloadsDir?.path}/$filename';

      // Start download
      var response = await http.Client().send(http.Request('GET', url));

      if (response.statusCode != 200) {
        throw Exception("Failed to download file: ${response.reasonPhrase}");
      }

      // Track progress
      int totalBytes = response.contentLength ?? 0;
      int receivedBytes = 0;

      // Write to file
      File file = File(savePath);
      var sink = file.openWrite();

      await for (var chunk in response.stream) {
        receivedBytes += chunk.length;
        sink.add(chunk);
        if (totalBytes > 0) {
          double progress = receivedBytes / totalBytes;
          onProgress(progress); // Update progress
        }
      }

      await sink.close();
      print("File downloaded to: $savePath");
    } catch (e) {
      print("Download failed: $e");
      throw Exception("Failed to download file.");
    }
  }
}
