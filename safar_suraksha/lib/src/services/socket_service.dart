import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  void connect(String baseUrl) {
    _socket = IO.io(baseUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build());

    _socket.onConnect((_) {
      print('Socket connected');
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
      _isConnected = false;
    });

    _socket.onConnectError((error) {
      print('Socket connection error: $error');
      _isConnected = false;
    });
  }

  void joinTouristRoom(String digitalId) {
    if (_isConnected) {
      _socket.emit('join_tourist', digitalId);
    }
  }

  void joinDashboard() {
    if (_isConnected) {
      _socket.emit('join_dashboard');
    }
  }

  void onEmergencyAlert(Function(Map<String, dynamic>) callback) {
    _socket.on('emergency_alert', (data) {
      callback(data);
    });
  }

  void onSafetyScoreUpdate(Function(Map<String, dynamic>) callback) {
    _socket.on('safety_score_update', (data) {
      callback(data);
    });
  }

  void onNewAlert(Function(Map<String, dynamic>) callback) {
    _socket.on('new_alert', (data) {
      callback(data);
    });
  }

  void disconnect() {
    _socket.disconnect();
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});
