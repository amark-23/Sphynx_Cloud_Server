import 'package:flutter/material.dart';
import '../models/file_item.dart';
import '../widgets/rename_button.dart';
import '../widgets/download_button.dart';
import '../widgets/delete_button.dart';
import '../services/api_service.dart';
import '../services/upload_service.dart';
import '../widgets/upload_button_with_progress.dart';
import '../widgets/stats_widget.dart';
import '../widgets/server_stats_widget.dart';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final UploadService uploadService = UploadService();
  final GlobalKey<StatsWidgetState> _statsKey = GlobalKey<StatsWidgetState>();

  List<FileItem> items = [];
  String currentFolder = '';
  double uploadProgress = 0.0;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchFiles();
    refreshStats();
  }

  /// Refresh the stats widget
  void refreshStats() {
    _statsKey.currentState?.fetchStats();
  }

  /// Fetch files in the current folder
  void fetchFiles({String folder = ''}) async {
    try {
      List<FileItem> fetchedItems = await apiService.getFiles(folder: folder);
      setState(() {
        items = fetchedItems;
        currentFolder = folder;
      });
      refreshStats(); // Refresh stats after fetching files
    } catch (e) {
      print("Error fetching files: $e");
    }
  }

  Widget buildFileItem(FileItem item) {
    return ListTile(
      leading: Icon(item.isFolder ? Icons.folder : Icons.insert_drive_file),
      title: Text(item.name),
      subtitle:
          item.isFolder
              ? const Text("Folder")
              : Text("Size: ${item.size ?? 'N/A'} bytes"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🖊️ Rename button
          RenameButton(
            fileName: item.name,
            onRenameSuccess: () => fetchFiles(folder: currentFolder),
          ),

          // ⬇️ Download button
          DownloadButton(fileName: item.name),

          // ❌ Delete button
          DeleteButton(
            fileName: item.name,
            onDeleteSuccess: () => fetchFiles(folder: currentFolder),
          ),
        ],
      ),
      onTap: () => onItemTap(item),
    );
  }

  /// Handle file or folder tap
  void onItemTap(FileItem item) {
    if (item.isFolder) {
      openFolder(item.name);
    } else {
      String fullPath =
          currentFolder.isEmpty ? item.name : '$currentFolder/${item.name}';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(fileName: fullPath),
        ),
      );
    }
  }

  /// Open a folder
  void openFolder(String folderName) {
    String newPath =
        currentFolder.isEmpty ? folderName : '$currentFolder/$folderName';
    fetchFiles(folder: newPath);
    refreshStats();
  }

  /// Go back to the previous folder
  void goBack() {
    if (currentFolder.isNotEmpty) {
      List<String> parts = currentFolder.split('/');
      parts.removeLast();
      fetchFiles(folder: parts.join('/'));
      refreshStats();
    }
  }

  /// Confirm file deletion
  void confirmDelete(String fileName) {
    String fullPath =
        currentFolder.isEmpty ? fileName : '$currentFolder/$fileName';

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
                  bool success = await apiService.deleteFile(fullPath);
                  if (success) {
                    setState(() {
                      items.removeWhere((item) => item.name == fileName);
                    });
                    refreshStats(); // Refresh after delete
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentFolder.isEmpty ? "Sphynx File Manager" : "📁 $currentFolder",
        ),
        leading:
            currentFolder.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: goBack,
                )
                : null,
        actions: [
          // Upload button in the AppBar with proper size
          SizedBox(
            height: 40,
            width: 40,
            child: UploadButtonWithProgress(
              onUpload: (onProgress) async {
                await uploadService.uploadFile(
                  folder: currentFolder,
                  onProgress: onProgress,
                );
                fetchFiles(
                  folder: currentFolder,
                ); // Refresh file list after upload
                refreshStats(); // Refresh stats after upload
              },
            ),
          ),
          const SizedBox(width: 10), // Right padding
        ],
      ),

      body: Column(
        children: [
          // Row to show Storage Stats and Server Stats side by side
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📊 Storage Stats (Left)
                Expanded(child: StatsWidget(key: _statsKey)),

                const SizedBox(width: 10), // Space between widgets
                // 🖥️ Server Stats (Right)
                const Expanded(child: ServerStatsWidget()),
              ],
            ),
          ),

          // 📁 File List
          Expanded(
            child:
                items.isEmpty
                    ? const Center(child: Text("No files or folders found"))
                    : ListView.builder(
                      itemCount: items.length,
                      itemBuilder:
                          (context, index) => buildFileItem(items[index]),
                    ),
          ),
        ],
      ),
    );
  }
}
