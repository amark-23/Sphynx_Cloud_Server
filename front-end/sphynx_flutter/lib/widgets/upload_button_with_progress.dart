import 'package:flutter/material.dart';

class UploadButtonWithProgress extends StatefulWidget {
  final Future<void> Function(Function(double) onProgress) onUpload;

  const UploadButtonWithProgress({Key? key, required this.onUpload})
    : super(key: key);

  @override
  _UploadButtonWithProgressState createState() =>
      _UploadButtonWithProgressState();
}

class _UploadButtonWithProgressState extends State<UploadButtonWithProgress> {
  double _progress = 0.0;
  bool _isUploading = false;

  /// Start upload and update progress
  Future<void> _startUpload() async {
    setState(() {
      _progress = 0.0;
      _isUploading = true;
    });

    try {
      await widget.onUpload((progress) {
        setState(() {
          _progress = progress.clamp(0.0, 1.0); // ✅ Smooth progress
        });
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload successful!")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() {
        _progress = 0.0;
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ✅ Show progress circle during upload
        if (_isUploading)
          SizedBox(
            width: 65,
            height: 65,
            child: CircularProgressIndicator(
              value: _progress > 0 ? _progress : null, // ✅ Show progress
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 6.0,
            ),
          ),

        // ✅ Show Upload button when not uploading
        if (!_isUploading)
          FloatingActionButton(
            onPressed: _startUpload,
            child: const Icon(Icons.upload),
          ),
      ],
    );
  }
}
