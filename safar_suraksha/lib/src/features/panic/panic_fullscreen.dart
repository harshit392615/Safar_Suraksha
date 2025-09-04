import 'package:flutter/material.dart';

class PanicFullscreen extends StatelessWidget {
  const PanicFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sos, size: 120, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'EMERGENCY',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 36),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Send Alert'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              )
            ],
          ),
        ),
      ),
    );
  }
}


