class Tourist {
  final String digitalId;
  final String name;
  final String nationality;
  final String phoneNumber;
  final List<EmergencyContact> emergencyContacts;
  final List<ItineraryItem> itinerary;
  final int safetyScore;
  final Location? currentLocation;
  final String riskLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime expiresAt;

  Tourist({
    required this.digitalId,
    required this.name,
    required this.nationality,
    required this.phoneNumber,
    required this.emergencyContacts,
    required this.itinerary,
    required this.safetyScore,
    this.currentLocation,
    required this.riskLevel,
    required this.isActive,
    required this.createdAt,
    required this.expiresAt,
  });

  factory Tourist.fromJson(Map<String, dynamic> json) {
    return Tourist(
      digitalId: json['digitalId'] ?? '',
      name: json['name'] ?? '',
      nationality: json['nationality'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emergencyContacts: (json['emergencyContacts'] as List?)
          ?.map((e) => EmergencyContact.fromJson(e))
          .toList() ?? [],
      itinerary: (json['itinerary'] as List?)
          ?.map((e) => ItineraryItem.fromJson(e))
          .toList() ?? [],
      safetyScore: json['safetyScore'] ?? 70,
      currentLocation: json['currentLocation'] != null 
          ? Location.fromJson(json['currentLocation']) 
          : null,
      riskLevel: json['riskLevel'] ?? 'LOW',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relationship;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }
}

class ItineraryItem {
  final String location;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final Location? coordinates;

  ItineraryItem({
    required this.location,
    this.checkIn,
    this.checkOut,
    this.coordinates,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      location: json['location'] ?? '',
      checkIn: json['checkIn'] != null ? DateTime.parse(json['checkIn']) : null,
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      coordinates: json['coordinates'] != null 
          ? Location.fromJson(json['coordinates']) 
          : null,
    );
  }
}

class Location {
  final double lat;
  final double lng;
  final DateTime? timestamp;

  Location({
    required this.lat,
    required this.lng,
    this.timestamp,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      timestamp: json['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp?.millisecondsSinceEpoch,
    };
  }
}

class Alert {
  final String id;
  final String touristId;
  final String alertType;
  final String severity;
  final Location location;
  final String description;
  final String status;
  final DateTime createdAt;

  Alert({
    required this.id,
    required this.touristId,
    required this.alertType,
    required this.severity,
    required this.location,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['_id'] ?? '',
      touristId: json['touristId'] ?? '',
      alertType: json['alertType'] ?? '',
      severity: json['severity'] ?? '',
      location: Location.fromJson(json['location']),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
