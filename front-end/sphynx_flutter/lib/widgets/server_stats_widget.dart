import 'package:flutter/material.dart';
import '../services/server_stats_service.dart';

class ServerStatsWidget extends StatefulWidget {
  const ServerStatsWidget({Key? key}) : super(key: key);

  @override
  _ServerStatsWidgetState createState() => _ServerStatsWidgetState();
}

class _ServerStatsWidgetState extends State<ServerStatsWidget> {
  final ServerStatsService _serverStatsService = ServerStatsService();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServerStats();
  }

  void _fetchServerStats() async {
    setState(() => _isLoading = true);
    final stats = await _serverStatsService.fetchServerStats();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_stats == null) {
      return const Center(child: Text("Failed to load server stats."));
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🖥️ Server Stats",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("💪 CPU Usage: ${_stats!['cpu_usage']}"),
            Text("💾 RAM Usage: ${_stats!['ram_used']}"),
            Text("📦 Disk Usage: ${_stats!['disk_used']}"),
            Text("🕰️ Uptime: ${_stats!['uptime']}"),
            Text("🖥️ OS: ${_stats!['system_info']['os']}"),
            Text("🏷️ Hostname: ${_stats!['system_info']['hostname']}"),
          ],
        ),
      ),
    );
  }
}
