import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'type': 'PANIC', 'severity': 'CRITICAL', 'desc': 'Emergency alert triggered', 'time': '2m ago'},
      {'type': 'GEOFENCE', 'severity': 'HIGH', 'desc': 'Entered high-risk zone', 'time': '15m ago'},
      {'type': 'ANOMALY', 'severity': 'MEDIUM', 'desc': 'Rapid displacement detected', 'time': '1h ago'},
    ];

    Color statusColor(String severity) {
      switch (severity) {
        case 'CRITICAL':
          return Colors.red;
        case 'HIGH':
          return Colors.orange;
        case 'MEDIUM':
          return Colors.amber;
        default:
          return Colors.green;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts & Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final a = alerts[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor(a['severity']!),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
              ),
              title: Text('${a['type']} • ${a['severity']}'),
              subtitle: Text(a['desc']!),
              trailing: Text(a['time']!, style: const TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}


