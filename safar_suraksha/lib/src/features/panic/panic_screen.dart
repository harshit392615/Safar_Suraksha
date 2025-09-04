import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/tourist_provider.dart';
import '../../services/location_service.dart';

class PanicScreen extends ConsumerStatefulWidget {
  const PanicScreen({super.key});

  @override
  ConsumerState<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends ConsumerState<PanicScreen> {
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourist = ref.watch(touristProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Panic'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade50,
              Colors.red.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Emergency Icon
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        spreadRadius: 10,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sos,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Emergency Message
                Text(
                  'EMERGENCY ALERT',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'This will send your location and emergency message to authorities and your emergency contacts.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 32),

                // Tourist Info
                if (tourist != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tourist Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Name: ${tourist.name}'),
                        Text('Digital ID: ${tourist.digitalId}'),
                        Text('Phone: ${tourist.phoneNumber}'),
                        Text('Nationality: ${tourist.nationality}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Emergency Contacts
                if (tourist?.emergencyContacts.isNotEmpty == true) ...[
                  Text(
                    'Emergency Contacts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...tourist!.emergencyContacts.map((contact) => 
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.red.shade600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(contact.phone),
                                Text(
                                  contact.relationship,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _callEmergencyContact(contact.phone),
                            icon: const Icon(Icons.phone, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                  const SizedBox(height: 24),
                ],

                // Emergency Message
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Message (Optional)',
                    hintText: 'Describe your emergency situation...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.message),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Panic Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _triggerPanic,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sos, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'SEND EMERGENCY ALERT',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _triggerPanic() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to get current location. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Send panic alert
      await ref.read(touristProvider.notifier).triggerPanic(
        message: _messageController.text.isNotEmpty 
            ? _messageController.text 
            : 'Emergency panic button activated',
      );

      if (mounted) {
        // Show success message
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Alert Sent'),
              ],
            ),
            content: const Text(
              'Your emergency alert has been sent to authorities and emergency contacts. Help is on the way.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close panic screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Also call emergency contacts
        final tourist = ref.read(touristProvider);
        if (tourist?.emergencyContacts.isNotEmpty == true) {
          for (final contact in tourist!.emergencyContacts) {
            await _callEmergencyContact(contact.phone);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send emergency alert: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _callEmergencyContact(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
