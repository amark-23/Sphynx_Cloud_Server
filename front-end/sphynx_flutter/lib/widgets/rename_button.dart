import 'package:flutter/material.dart';
import '../widgets/rename_dialog.dart';

class RenameButton extends StatelessWidget {
  final String fileName;
  final Function onRenameSuccess;

  const RenameButton({
    Key? key,
    required this.fileName,
    required this.onRenameSuccess,
  }) : super(key: key);

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => RenameDialog(
            oldName: fileName,
            onRenameSuccess: () => onRenameSuccess(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: () => _showRenameDialog(context),
    );
  }
}
