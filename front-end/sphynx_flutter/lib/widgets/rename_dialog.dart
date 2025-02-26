import 'package:flutter/material.dart';
import '../services/rename_service.dart';

class RenameDialog extends StatefulWidget {
  final String oldName;
  final Function onRenameSuccess;

  const RenameDialog({
    Key? key,
    required this.oldName,
    required this.onRenameSuccess,
  }) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final TextEditingController _renameController = TextEditingController();
  final RenameService _renameService = RenameService();

  @override
  void initState() {
    super.initState();
    _renameController.text = widget.oldName;
  }

  void renameFile() async {
    String newName = _renameController.text.trim();
    if (newName.isEmpty || newName == widget.oldName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a different name")),
      );
      return;
    }

    bool success = await _renameService.renameFile(widget.oldName, newName);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Renamed to '$newName'")));
      widget.onRenameSuccess(); // Refresh file list
      Navigator.pop(context); // Close dialog
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rename failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename File"),
      content: TextField(
        controller: _renameController,
        decoration: const InputDecoration(hintText: "Enter new name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(onPressed: renameFile, child: const Text("Rename")),
      ],
    );
  }
}
