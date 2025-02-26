import 'package:flutter/material.dart';
import '../services/stats_service.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  StatsWidgetState createState() => StatsWidgetState();
}

class StatsWidgetState extends State<StatsWidget> {
  final StatsService _statsService = StatsService();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  // 🔄 Public method to refresh stats
  void fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _statsService.fetchStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load stats: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _stats == null
                ? const Center(child: Text("Failed to load stats."))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📊 Storage Stats",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("📁 Total Files: ${_stats!['total_files']}"),
                    Text("💾 Total Size: ${_stats!['total_size']}"),
                    Text(
                      "🕰️ Most Recent Upload: ${_stats!['most_recent_upload']}",
                    ),
                  ],
                ),
      ),
    );
  }
}
