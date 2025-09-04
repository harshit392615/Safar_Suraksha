import 'package:flutter/material.dart';

class FamilyTrackingPage extends StatelessWidget {
  const FamilyTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': 'Alice', 'status': 'Safe', 'distance': '0.5 km'},
      {'name': 'Bob', 'status': 'Caution', 'distance': '2.1 km'},
      {'name': 'Charlie', 'status': 'Safe', 'distance': '4.8 km'},
    ];
    Color badge(String s) => s == 'Safe' ? Colors.green : Colors.orange;
    return Scaffold(
      appBar: AppBar(title: const Text('Family Tracking')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, i) {
          final m = members[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))]),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: badge(m['status']!), child: const Icon(Icons.person, color: Colors.white)),
              title: Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('Status: ${m['status']} • ${m['distance']} away'),
              trailing: IconButton(icon: const Icon(Icons.location_pin), onPressed: () {}),
            ),
          );
        },
      ),
    );
  }
}


