import 'package:flutter/material.dart';

class TouristIdPage extends StatelessWidget {
  const TouristIdPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tourist ID')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
            ],
          ),
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: const [Icon(Icons.person, size: 40), SizedBox(width: 8), Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold))]),
              const Divider(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Digital ID'), Text('TID_XXXX1234')]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Passport'), Text('N1234567')]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Aadhaar'), Text('XXXX-XXXX-1234')]),
              const SizedBox(height: 16),
              Container(height: 120, width: 120, color: Colors.indigo.shade50, child: const Center(child: Text('QR'))),
              const SizedBox(height: 8),
              const Text('Show this at checkpoints to verify your identity', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}


