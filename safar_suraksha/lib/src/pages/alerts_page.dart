import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'type': 'PANIC', 'severity': 'CRITICAL', 'desc': 'Emergency alert triggered', 'time': '2m ago'},
      {'type': 'GEOFENCE', 'severity': 'HIGH', 'desc': 'Entered high-risk zone', 'time': '15m ago'},
      {'type': 'ANOMALY', 'severity': 'MEDIUM', 'desc': 'Rapid displacement detected', 'time': '1h ago'},
    ];
    Color status(String s) => s == 'CRITICAL' ? Colors.red : s == 'HIGH' ? Colors.orange : Colors.amber;
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          final a = alerts[i];
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4))]),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: status(a['severity']!), child: const Icon(Icons.warning_amber_rounded, color: Colors.white)),
              title: Text('${a['type']} • ${a['severity']}'),
              subtitle: Text(a['desc']!),
              trailing: Text(a['time']!, style: const TextStyle(color: Colors.grey)),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: alerts.length,
      ),
    );
  }
}


