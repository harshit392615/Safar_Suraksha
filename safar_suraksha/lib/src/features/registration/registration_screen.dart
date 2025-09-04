import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tourist_provider.dart';
import '../../models/tourist.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passportController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _nameController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _visitDurationController = TextEditingController();

  final List<EmergencyContact> _emergencyContacts = [];
  final List<ItineraryItem> _itinerary = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _passportController.dispose();
    _aadhaarController.dispose();
    _nameController.dispose();
    _nationalityController.dispose();
    _phoneController.dispose();
    _visitDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Registration'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passportController,
                      decoration: const InputDecoration(
                        labelText: 'Passport Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter passport number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _aadhaarController,
                      decoration: const InputDecoration(
                        labelText: 'Aadhaar Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aadhaar number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nationalityController,
                      decoration: const InputDecoration(
                        labelText: 'Nationality',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your nationality';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _visitDurationController,
                      decoration: const InputDecoration(
                        labelText: 'Visit Duration (days)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter visit duration';
                        }
                        final days = int.tryParse(value);
                        if (days == null || days <= 0) {
                          return 'Please enter a valid number of days';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Emergency Contacts'),
                    const SizedBox(height: 16),
                    ..._emergencyContacts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final contact = entry.value;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Contact ${index + 1}'),
                              Text('Name: ${contact.name}'),
                              Text('Phone: ${contact.phone}'),
                              Text('Relationship: ${contact.relationship}'),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _emergencyContacts.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: _addEmergencyContact,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Emergency Contact'),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Trip Itinerary'),
                    const SizedBox(height: 16),
                    ..._itinerary.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Location ${index + 1}'),
                              Text('Place: ${item.location}'),
                              if (item.checkIn != null)
                                Text('Check-in: ${item.checkIn!.toLocal().toString().split(' ')[0]}'),
                              if (item.checkOut != null)
                                Text('Check-out: ${item.checkOut!.toLocal().toString().split(' ')[0]}'),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _itinerary.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    ElevatedButton.icon(
                      onPressed: _addItineraryItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Itinerary Item'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitRegistration,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Register Tourist'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _addEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => _EmergencyContactDialog(
        onSave: (contact) {
          setState(() {
            _emergencyContacts.add(contact);
          });
        },
      ),
    );
  }

  void _addItineraryItem() {
    showDialog(
      context: context,
      builder: (context) => _ItineraryItemDialog(
        onSave: (item) {
          setState(() {
            _itinerary.add(item);
          });
        },
      ),
    );
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    if (_emergencyContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one emergency contact')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(touristProvider.notifier).registerTourist(
        passportNumber: _passportController.text,
        aadhaarNumber: _aadhaarController.text,
        name: _nameController.text,
        nationality: _nationalityController.text,
        phoneNumber: _phoneController.text,
        emergencyContacts: _emergencyContacts,
        itinerary: _itinerary,
        visitDuration: int.parse(_visitDurationController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
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
}

class _EmergencyContactDialog extends StatefulWidget {
  final Function(EmergencyContact) onSave;

  const _EmergencyContactDialog({required this.onSave});

  @override
  State<_EmergencyContactDialog> createState() => _EmergencyContactDialogState();
}

class _EmergencyContactDialogState extends State<_EmergencyContactDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Emergency Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: _relationshipController,
            decoration: const InputDecoration(labelText: 'Relationship'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _phoneController.text.isNotEmpty &&
                _relationshipController.text.isNotEmpty) {
              widget.onSave(EmergencyContact(
                name: _nameController.text,
                phone: _phoneController.text,
                relationship: _relationshipController.text,
              ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ItineraryItemDialog extends StatefulWidget {
  final Function(ItineraryItem) onSave;

  const _ItineraryItemDialog({required this.onSave});

  @override
  State<_ItineraryItemDialog> createState() => _ItineraryItemDialogState();
}

class _ItineraryItemDialogState extends State<_ItineraryItemDialog> {
  final _locationController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Itinerary Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(_checkIn == null ? 'Select Check-in Date' : 'Check-in: ${_checkIn!.toLocal().toString().split(' ')[0]}'),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _checkIn = date;
                });
              }
            },
          ),
          ListTile(
            title: Text(_checkOut == null ? 'Select Check-out Date' : 'Check-out: ${_checkOut!.toLocal().toString().split(' ')[0]}'),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _checkIn ?? DateTime.now(),
                firstDate: _checkIn ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() {
                  _checkOut = date;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_locationController.text.isNotEmpty) {
              widget.onSave(ItineraryItem(
                location: _locationController.text,
                checkIn: _checkIn,
                checkOut: _checkOut,
              ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
