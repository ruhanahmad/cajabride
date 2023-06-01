import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapController extends StatefulWidget {
  const MapController({super.key});

  @override
  State<MapController> createState() => _MapControllerState();
}

class _MapControllerState extends State<MapController> {
    GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  Polyline? _polyline;
  double _estimatedFare = 0.0;

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _placeMarkersAndRoute(LatLng origin, LatLng destination) async {
    _markers.add(
      Marker(
        markerId: MarkerId('origin'),
        position: origin,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    setState(() {
      _polylineCoordinates.clear();
      _polyline = null;
      _estimatedFare = 0.0;
    });

    String url =
        'https://maps.googleapis.com/maps/api/directions/json' +
            '?origin=${origin.latitude},${origin.longitude}' +
            '&destination=${destination.latitude},${destination.longitude}' +
            '&key=YOUR_API_KEY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final routes = jsonData['routes'];

      if (routes.isNotEmpty) {
        final legs = routes[0]['legs'];

        if (legs.isNotEmpty) {
          final steps = legs[0]['steps'];

          for (int i = 0; i < steps.length; i++) {
            final polylinePoints = steps[i]['polyline']['points'];
            final decodedPolylinePoints =
                PolylinePoints().decodePolyline(polylinePoints);
                // Polyline(polylineId: polylinePoints);
             

            for (int j = 0; j < decodedPolylinePoints.length; j++) {
              _polylineCoordinates.add(LatLng(
                decodedPolylinePoints[j].latitude,
                decodedPolylinePoints[j].longitude,
              ));
            }
          }

          setState(() {
            _polyline = Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
            );
            // _estimatedFare = _calculateEstimatedFare(legs[0]['distance']['value']);
          });

          _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: origin,
              northeast: destination,
            ),
            100,
          ));
            Future<double> calculateFare( leg) async {
    // Get the distance between the two points
    double distance = await leg.distance;

    // Get the time it will take to travel between the two points
    double time = await leg.duration;

    // Calculate the fare
    double fare = distance * 0.5 + time * 0.2;

    return fare;
  }
        }

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}