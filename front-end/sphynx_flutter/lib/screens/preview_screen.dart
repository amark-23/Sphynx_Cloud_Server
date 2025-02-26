import 'package:flutter/material.dart';
import '../services/preview_service.dart';

class PreviewScreen extends StatefulWidget {
  final String fileName;

  const PreviewScreen({Key? key, required this.fileName}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final PreviewService previewService = PreviewService();
  late Future<Map<String, dynamic>> previewFuture;

  @override
  void initState() {
    super.initState();
    previewFuture = previewService.previewFile(widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview: ${widget.fileName}")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: previewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Failed to load preview: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data['type'] == 'image') {
              return Center(child: Image.network(data['url']));
            } else if (data['type'] == 'text') {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(data['content'] ?? 'No content available'),
              );
            } else {
              return const Center(
                child: Text("Preview not available for this file type."),
              );
            }
          } else {
            return const Center(child: Text("No preview available."));
          }
        },
      ),
    );
  }
}
