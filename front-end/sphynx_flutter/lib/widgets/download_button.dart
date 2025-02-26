import 'package:flutter/material.dart';
import '../services/download_service.dart';

class DownloadButton extends StatefulWidget {
  final String fileName;

  const DownloadButton({Key? key, required this.fileName}) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  final DownloadService _downloadService = DownloadService();
  double _progress = 0.0;
  bool _isDownloading = false;

  void startDownload() async {
    setState(() {
      _progress = 0.0;
      _isDownloading = true;
    });

    try {
      await _downloadService.downloadFile(widget.fileName, (progress) {
        setState(() => _progress = progress);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.fileName} downloaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download ${widget.fileName}: $e")),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isDownloading
        ? SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(value: _progress, strokeWidth: 3.0),
        )
        : IconButton(
          icon: const Icon(Icons.download, color: Colors.green),
          onPressed: startDownload,
        );
  }
}
