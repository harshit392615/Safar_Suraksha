import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tourist.dart';
import '../services/location_service.dart';
import '../core/api_client.dart';
import 'package:dio/dio.dart';

class TouristNotifier extends StateNotifier<Tourist?> {
  TouristNotifier(this._dio) : super(null);

  final Dio _dio;
  bool _isTrackingEnabled = false;

  Future<void> registerTourist({
    required String passportNumber,
    required String aadhaarNumber,
    required String name,
    required String nationality,
    required String phoneNumber,
    required List<EmergencyContact> emergencyContacts,
    required List<ItineraryItem> itinerary,
    required int visitDuration,
  }) async {
    try {
      final response = await _dio.post('/tourists/register-tourist', data: {
        'passportNumber': passportNumber,
        'aadhaarNumber': aadhaarNumber,
        'name': name,
        'nationality': nationality,
        'phoneNumber': phoneNumber,
        'emergencyContacts': emergencyContacts.map((e) => {
          'name': e.name,
          'phone': e.phone,
          'relationship': e.relationship,
        }).toList(),
        'itinerary': itinerary.map((e) => {
          'location': e.location,
          'checkIn': e.checkIn?.toIso8601String(),
          'checkOut': e.checkOut?.toIso8601String(),
          'coordinates': e.coordinates?.toJson(),
        }).toList(),
        'visitDuration': visitDuration,
      });

      if (response.data['success'] == true) {
        final digitalId = response.data['digitalId'];
        await _saveDigitalId(digitalId);
        // Fetch the created tourist data
        await _fetchTouristData(digitalId);
      }
    } catch (e) {
      print('Error registering tourist: $e');
      rethrow;
    }
  }

  Future<void> _fetchTouristData(String digitalId) async {
    try {
      final response = await _dio.get('/tourists/dashboard/tourists');
      if (response.data['success'] == true) {
        final tourists = response.data['data']['tourists'] as List;
        final touristData = tourists.firstWhere(
          (t) => t['digitalId'] == digitalId,
          orElse: () => null,
        );
        if (touristData != null) {
          state = Tourist.fromJson(touristData);
        }
      }
    } catch (e) {
      print('Error fetching tourist data: $e');
    }
  }

  Future<void> updateLocation() async {
    if (state == null) return;

    final position = await LocationService.getCurrentPosition();
    if (position == null) return;

    try {
      final response = await _dio.post('/tourists/update-location', data: {
        'digitalId': state!.digitalId,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      if (response.data['success'] == true) {
        // Update local state with new safety score
        final newSafetyScore = response.data['safetyScore'];
        final newRiskLevel = response.data['riskLevel'];
        
        state = state!.copyWith(
          safetyScore: newSafetyScore,
          riskLevel: newRiskLevel,
          currentLocation: Location(
            lat: position.latitude,
            lng: position.longitude,
            timestamp: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> triggerPanic({String? message}) async {
    if (state == null) return;

    final position = await LocationService.getCurrentPosition();
    if (position == null) return;

    try {
      final response = await _dio.post('/iot/panic', data: {
        'digitalId': state!.digitalId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'message': message ?? 'Emergency panic button activated',
      });

      return response.data;
    } catch (e) {
      print('Error triggering panic: $e');
      rethrow;
    }
  }

  Future<void> loadSavedTourist() async {
    final prefs = await SharedPreferences.getInstance();
    final digitalId = prefs.getString('digitalId');
    if (digitalId != null) {
      await _fetchTouristData(digitalId);
    }
  }

  Future<void> _saveDigitalId(String digitalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('digitalId', digitalId);
  }

  void toggleTracking() {
    _isTrackingEnabled = !_isTrackingEnabled;
  }

  bool get isTrackingEnabled => _isTrackingEnabled;
}

final touristProvider = StateNotifierProvider<TouristNotifier, Tourist?>((ref) {
  final dio = ref.watch(dioProvider);
  return TouristNotifier(dio);
});

// Extension to add copyWith method to Tourist
extension TouristCopyWith on Tourist {
  Tourist copyWith({
    String? digitalId,
    String? name,
    String? nationality,
    String? phoneNumber,
    List<EmergencyContact>? emergencyContacts,
    List<ItineraryItem>? itinerary,
    int? safetyScore,
    Location? currentLocation,
    String? riskLevel,
    bool? isActive,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return Tourist(
      digitalId: digitalId ?? this.digitalId,
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      itinerary: itinerary ?? this.itinerary,
      safetyScore: safetyScore ?? this.safetyScore,
      currentLocation: currentLocation ?? this.currentLocation,
      riskLevel: riskLevel ?? this.riskLevel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
