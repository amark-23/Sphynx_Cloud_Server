import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeleteButton extends StatelessWidget {
  final String fileName;
  final bool isFolder;
  final Function onDeleteSuccess;

  const DeleteButton({
    Key? key,
    required this.fileName,
    required this.isFolder,
    required this.onDeleteSuccess,
  }) : super(key: key);

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete ${isFolder ? 'Folder' : 'File'}?"),
            content: Text("Are you sure you want to delete '${fileName}'?"),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${isFolder ? 'Folder' : 'File'} deleted successfully!",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to delete ${isFolder ? 'folder' : 'file'}.",
                        ),
                      ),
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

