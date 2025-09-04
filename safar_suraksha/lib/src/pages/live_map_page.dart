import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveMapPage extends StatefulWidget {
  const LiveMapPage({super.key});
  @override
  State<LiveMapPage> createState() => _LiveMapPageState();
}

class _LiveMapPageState extends State<LiveMapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Map')),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(target: LatLng(28.6139, 77.2090), zoom: 12),
          onMapCreated: (c) => _controller = c,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: _markers,
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(children: const [Icon(Icons.shield, color: Colors.green), SizedBox(width: 8), Text('Safe • No active alerts')]),
            ),
          ),
        ),
      ]),
    );
  }
}


