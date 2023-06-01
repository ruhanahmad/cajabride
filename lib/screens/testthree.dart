import 'dart:convert';
import 'package:cajabride/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../controller/userController.dart';

class AddressEntryScreened extends StatefulWidget {
  @override
  _AddressEntryScreenedState createState() => _AddressEntryScreenedState();
}

class _AddressEntryScreenedState extends State<AddressEntryScreened> {
  // TextEditingController _addressController = TextEditingController();
  UserController userController = Get.put(UserController());
  List<dynamic> _addressSuggestions = [];
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};



  void _getAddressSuggestions(String input) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json' +
        '?input=$input' +
        '&types=address' +
        '&key=AIzaSyCZJDq4ZZiah_srzkzjQDtxnXVE-gbf85M';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final predictions = jsonData['predictions'];

      setState(() {
        _addressSuggestions = predictions
            .map((prediction) => prediction['description'])
            .toList();
      });
      
    }
  }
  Future<LatLng> fetchLatLng(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    print(locations);
    if (locations.isNotEmpty) {
      Location location = locations.first;
       
      return LatLng(location.latitude, location.longitude);
      
    }
  } catch (e) {
    print('Error fetching coordinates: $e');
  }
  // return ;
  return LatLng(122122.2, 22323.5);
}


  void _moveToLocation(LatLng location) {
    _mapController!.animateCamera(CameraUpdate.newLatLng(location));

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selectedLocation'),
          position: location,
        ),
      );
    });
  }
  //   @override
  // void dispose() {
  //   userController.locationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Entry'),
         actions: [
          GestureDetector(
            onTap: () {
              Get.to(HomePage());
            },
            child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextFormField(
                controller: userController.locationController,
                onChanged: _getAddressSuggestions,
                decoration: InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _addressSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_addressSuggestions[index]),
                    onTap: () async {
                      userController.locationController.text = _addressSuggestions[index];
                           LatLng latLngs = await fetchLatLng(userController.locationController.text);
                          _moveToLocation(latLngs);
                      final placeDetailsUrl =
                          'https://maps.googleapis.com/maps/api/place/details/json' +
                              '?place_id=PLACE_ID' +
                              '&fields=geometry' +
                              '&key=AIzaSyCZJDq4ZZiah_srzkzjQDtxnXVE-gbf85M';
        
                      final placeResponse = await http.get(Uri.parse(placeDetailsUrl));
        
                      if (placeResponse.statusCode == 200) {
                        final placeJsonData = jsonDecode(placeResponse.body);
                        // final location = placeJsonData['result']['geometry']['location'];
                        // final latitude = location['lat'];
                        // final longitude = location['lng'];
        
                        // _moveToLocation(LatLng(latitude, longitude));
                      }
        
                      setState(() {
                        _addressSuggestions.clear();
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.422, -122.084),
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
