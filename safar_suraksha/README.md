# Safar Suraksha - Tourist Safety Platform

A Flutter-based mobile application for digital tourist ID management and safety monitoring.

## Features

- **Digital Tourist Registration**: KYC-based registration with blockchain ID generation
- **Real-time Location Tracking**: Opt-in GPS tracking with safety score calculation
- **Emergency Panic Button**: One-tap emergency alert with location sharing
- **Safety Score Monitoring**: AI-based anomaly detection and risk assessment
- **Google Maps Integration**: Real-time location display and geofencing alerts
- **Socket.IO Real-time Updates**: Live safety score and alert notifications
- **Emergency Contact Management**: Quick access to emergency contacts

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Google Maps API Key
- Backend API running on `http://10.0.2.2:3000` (Android emulator) or your local IP

### Installation

1. **Install Dependencies**
   ```bash
   cd frontend
   flutter pub get
   ```

2. **Configure Google Maps**
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`

3. **Configure API Endpoint**
   - For Android emulator: `http://10.0.2.2:3000` (default)
   - For physical device: Update `baseUrlProvider` in `lib/src/core/api_client.dart` with your computer's IP

4. **Run the App**
   ```bash
   flutter run
   ```

## App Flow

1. **Registration**: Tourist registers with passport/Aadhaar, emergency contacts, and itinerary
2. **Home Screen**: Shows safety score, current location on map, and tracking status
3. **Location Tracking**: Opt-in background location updates sent to backend
4. **Panic Button**: Emergency alert with location sharing to authorities and contacts
5. **Real-time Updates**: Socket.IO connection for live safety score and alert updates

## API Integration

The app integrates with the backend APIs:
- `POST /api/tourists/register-tourist` - Tourist registration
- `POST /api/tourists/update-location` - Location updates
- `POST /api/iot/panic` - Emergency panic alert
- `GET /api/tourists/dashboard/tourists` - Tourist data retrieval

## Permissions

The app requires the following permissions:
- `INTERNET` - API communication
- `ACCESS_FINE_LOCATION` - GPS location
- `ACCESS_COARSE_LOCATION` - Network location
- `CALL_PHONE` - Emergency contact calling
- `WAKE_LOCK` - Background location tracking
- `FOREGROUND_SERVICE` - Background services

## Architecture

- **State Management**: Riverpod for reactive state management
- **HTTP Client**: Dio for API communication
- **Real-time**: Socket.IO for live updates
- **Location**: Geolocator for GPS services
- **Maps**: Google Maps Flutter plugin
- **Background Tasks**: WorkManager for location updates

## Development

### Project Structure
```
lib/
├── src/
│   ├── app.dart                 # Main app configuration
│   ├── core/
│   │   └── api_client.dart      # HTTP client setup
│   ├── models/
│   │   └── tourist.dart         # Data models
│   ├── providers/
│   │   └── tourist_provider.dart # State management
│   ├── services/
│   │   ├── location_service.dart # Location utilities
│   │   └── socket_service.dart   # Socket.IO client
│   └── features/
│       ├── home/
│       │   └── home_screen.dart  # Main dashboard
│       ├── registration/
│       │   └── registration_screen.dart # Tourist registration
│       └── panic/
│           └── panic_screen.dart # Emergency panic
└── main.dart                    # App entry point
```

### Key Components

- **TouristProvider**: Manages tourist state, registration, and location updates
- **LocationService**: Handles GPS permissions and location tracking
- **SocketService**: Manages real-time WebSocket connections
- **HomeScreen**: Main dashboard with map, safety score, and panic button
- **RegistrationScreen**: Multi-step tourist registration form
- **PanicScreen**: Emergency alert interface with contact calling

## Testing

1. **Backend API**: Ensure backend is running and accessible
2. **Location Services**: Test on physical device for accurate GPS
3. **Emergency Features**: Verify panic button and contact calling
4. **Real-time Updates**: Test Socket.IO connection and live updates

## Production Considerations

- Replace development API endpoints with production URLs
- Implement proper error handling and retry logic
- Add offline support and data caching
- Implement proper security measures for API keys
- Add comprehensive logging and analytics
- Test on various Android devices and versions
