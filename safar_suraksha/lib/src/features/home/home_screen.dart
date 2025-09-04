import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/api_client.dart';
import '../../providers/tourist_provider.dart';
import '../../services/location_service.dart';
import '../../services/socket_service.dart';
import '../panic/panic_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isTrackingEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _setupSocketListeners();
  }

  void _initializeLocation() async {
    final tourist = ref.read(touristProvider);
    if (tourist != null) {
      await ref.read(touristProvider.notifier).loadSavedTourist();
    }
  }

  void _setupSocketListeners() {
    final socketService = ref.read(socketServiceProvider);
    final baseUrl = ref.read(baseUrlProvider);
    
    socketService.connect(baseUrl);
    
    final tourist = ref.read(touristProvider);
    if (tourist != null) {
      socketService.joinTouristRoom(tourist.digitalId);
    }

    socketService.onEmergencyAlert((data) {
      if (mounted) {
        _showEmergencyAlert(data);
      }
    });

    socketService.onSafetyScoreUpdate((data) {
      if (mounted) {
        _updateSafetyScore(data);
      }
    });
  }

  void _showEmergencyAlert(Map<String, dynamic> data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: Text(data['message'] ?? 'Emergency situation detected'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _updateSafetyScore(Map<String, dynamic> data) {
    // Update UI with new safety score
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Safety Score Updated: ${data['safetyScore']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tourist = ref.watch(touristProvider);
    final dio = ref.watch(dioProvider);

    if (tourist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Safar Suraksha')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No tourist profile found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/registration');
                },
                child: const Text('Register as Tourist'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safar Suraksha'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _toggleTracking,
            icon: Icon(_isTrackingEnabled ? Icons.location_on : Icons.location_off),
            tooltip: _isTrackingEnabled ? 'Disable Tracking' : 'Enable Tracking',
          ),
        ],
      ),
      body: Column(
        children: [
          // Safety Score Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getSafetyScoreColor(tourist.safetyScore),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Safety Score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${tourist.safetyScore}/100',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Risk Level: ${tourist.riskLevel}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Map
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _updateMapLocation();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  tourist.currentLocation?.lat ?? 28.6139,
                  tourist.currentLocation?.lng ?? 77.2090,
                ),
                zoom: 15.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          // Tourist Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${tourist.name}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Digital ID: ${tourist.digitalId}'),
                Text('Nationality: ${tourist.nationality}'),
                if (tourist.currentLocation != null)
                  Text('Last Location: ${tourist.currentLocation!.lat.toStringAsFixed(4)}, ${tourist.currentLocation!.lng.toStringAsFixed(4)}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _isTrackingEnabled ? Icons.location_on : Icons.location_off,
                      color: _isTrackingEnabled ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(_isTrackingEnabled ? 'Tracking Enabled' : 'Tracking Disabled'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PanicScreen(),
            ),
          );
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.sos, color: Colors.white),
        label: const Text('PANIC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Color _getSafetyScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _updateMapLocation() {
    final tourist = ref.read(touristProvider);
    if (tourist?.currentLocation != null && _mapController != null) {
      final location = tourist!.currentLocation!;
      final position = LatLng(location.lat, location.lng);
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(position),
      );

      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('current_location'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: 'Last updated: ${location.timestamp?.toLocal().toString().split('.')[0] ?? 'Unknown'}',
            ),
          ),
        };
      });
    }
  }

  void _toggleTracking() async {
    final hasPermission = await LocationService.requestLocationPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission required for tracking')),
      );
      return;
    }

    setState(() {
      _isTrackingEnabled = !_isTrackingEnabled;
    });

    if (_isTrackingEnabled) {
      // Start location tracking
      LocationService.getLocationStream().listen((position) {
        ref.read(touristProvider.notifier).updateLocation();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location tracking enabled')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location tracking disabled')),
      );
    }
  }
}

