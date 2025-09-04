import 'package:flutter/material.dart';

class PanicPage extends StatefulWidget {
  const PanicPage({super.key});
  @override
  State<PanicPage> createState() => _PanicPageState();
}

class _PanicPageState extends State<PanicPage> {
  bool _sending = false;
  String _status = 'Ready to send emergency alert';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(backgroundColor: Colors.red, title: const Text('Panic Mode'), foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sos, size: 120, color: Colors.white),
            const SizedBox(height: 16),
            Text(_status, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sending ? null : _sendPanic,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16)),
              child: _sending ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()) : const Text('Send Alert'),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPanic() async {
    setState(() {
      _sending = true;
      _status = 'Sending alert with live location...';
    });
    // Mock live location emit loop
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
    }
    if (!mounted) return;
    setState(() {
      _sending = false;
      _status = 'Alert sent to authorities and contacts';
    });
  }
}


