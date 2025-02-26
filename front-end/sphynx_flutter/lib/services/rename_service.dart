import 'package:http/http.dart' as http;

class RenameService {
  final String baseUrl = "http://192.168.2.5:5000";

  /// Rename file or folder
  Future<bool> renameFile(String oldName, String newName) async {
    final response = await http.put(
      Uri.parse('$baseUrl/rename?old_name=$oldName&new_name=$newName'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Rename failed: ${response.body}');
      return false;
    }
  }
}
