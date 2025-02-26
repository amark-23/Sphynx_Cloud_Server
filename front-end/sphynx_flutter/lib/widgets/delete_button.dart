import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeleteButton extends StatelessWidget {
  final String fileName;
  final Function onDeleteSuccess;

  const DeleteButton({
    Key? key,
    required this.fileName,
    required this.onDeleteSuccess,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete $fileName?"),
            content: const Text("Are you sure you want to delete this file?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  bool success = await ApiService().deleteFile(fileName);
                  if (success) {
                    onDeleteSuccess();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to delete file.")),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => _confirmDelete(context),
    );
  }
}
