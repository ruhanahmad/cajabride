import 'package:flutter/material.dart';
import 'package:cajabride/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/userController.dart';



class SelectMapScreen extends StatefulWidget {
  const SelectMapScreen({super.key});

  @override
  State<SelectMapScreen> createState() => _SelectMapScreenState();
}

class _SelectMapScreenState extends State<SelectMapScreen> {
    UserController userController = Get.put(UserController());
    LatLng? _selectedLocation;
     void _selectLocation(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address = placemark.name! + ', ' + placemark.locality!;
      userController.locationController.text = address;
    }

    setState(() {
      _selectedLocation = location;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Column(
        children: [
           Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.422, -122.084),
                zoom: 14,
              ),
              onTap: _selectLocation,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                      ),
                    }
                  : {},
            ),
          ),
        ],
      ),),
    );
  }
}