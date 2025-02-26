class FileItem {
  final String name;
  final bool isFolder;
  final int? size;
  final String lastModified;

  FileItem({
    required this.name,
    required this.isFolder,
    this.size,
    required this.lastModified,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      name: json['name'],
      isFolder: json['is_folder'] ?? false,
      size: json['size'],
      lastModified: json['last_modified'] ?? '',
    );
  }
}
