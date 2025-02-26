import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  final String baseUrl = "http://192.168.2.5:5000";

  Future<void> uploadFile({
    required String folder,
    required Function(double) onProgress,
  }) async {
    // Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return; // User canceled

    File originalFile = File(result.files.single.path!);
    String extension = path.extension(originalFile.path); // Get file extension

    // ✅ Create temp file with original extension
    String tempPath =
        '${originalFile.parent.path}/upload_temp_${DateTime.now().millisecondsSinceEpoch}$extension';
    File tempFile = await originalFile.copy(tempPath);

    try {
      // Upload request
      var uri = Uri.parse('$baseUrl/upload?folder=$folder');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', tempFile.path));

      int totalBytes = tempFile.lengthSync();
      int bytesSent = 0;

      // Track upload progress
      var stream = request.send();

      stream.asStream().listen(
        (response) {
          response.stream.listen(
            (chunk) {
              bytesSent += chunk.length;
              double progress = bytesSent / totalBytes;
              onProgress(progress); // ✅ Smooth progress update
            },
            onDone: () async {
              onProgress(1.0); // ✅ Upload complete
              await tempFile.delete(); // ✅ Clean up temp file
            },
            onError: (e) => onProgress(0.0),
          );
        },
        onError: (error) {
          print("Upload failed: $error");
          onProgress(0.0);
        },
      );

      await stream; // Ensure upload completes
    } finally {
      // ✅ Ensure temp file is removed even if upload fails
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }
}
