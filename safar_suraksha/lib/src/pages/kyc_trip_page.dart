import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KycTripPage extends StatefulWidget {
  const KycTripPage({super.key});
  @override
  State<KycTripPage> createState() => _KycTripPageState();
}

class _KycTripPageState extends State<KycTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _passport = TextEditingController();
  final _aadhaar = TextEditingController();
  final _emergency = TextEditingController();
  final _itinerary = TextEditingController();

  @override
  void dispose() {
    _passport.dispose();
    _aadhaar.dispose();
    _emergency.dispose();
    _itinerary.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC & Trip Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tourist KYC', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(decoration: const InputDecoration(labelText: 'Passport Number', border: OutlineInputBorder()), controller: _passport),
              const SizedBox(height: 12),
              TextFormField(decoration: const InputDecoration(labelText: 'Aadhaar Number', border: OutlineInputBorder()), controller: _aadhaar),
              const SizedBox(height: 16),
              Text('Emergency Contacts', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(decoration: const InputDecoration(labelText: 'Primary Contact Number', border: OutlineInputBorder()), controller: _emergency),
              const SizedBox(height: 16),
              Text('Trip Itinerary', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _itinerary,
                decoration: const InputDecoration(labelText: 'Planned route (free text)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.goNamed('dashboard'),
                  child: const Text('Save & Continue'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


