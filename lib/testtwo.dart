import 'dart:convert';
import 'package:cajabride/controller/userController.dart';
import 'package:cajabride/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class AddressEntryScreen extends StatefulWidget {
  @override
  _AddressEntryScreenState createState() => _AddressEntryScreenState();
}

class _AddressEntryScreenState extends State<AddressEntryScreen> {
    UserController userController = Get.put(UserController());
  TextEditingController _addressController = TextEditingController();
  late GoogleMapController _mapController;
Set<Marker> _markers = Set<Marker>();

  List<dynamic> _addressSuggestions = [];

  @override
  void dispose() {
    userController.locationController.dispose();
    super.dispose();
  }

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

  void _moveToLocation(LatLng location) {
  _mapController.animateCamera(CameraUpdate.newLatLng(location));

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
                  onTap: () {
                    userController.locationController.text = _addressSuggestions[index];
                     _moveToLocation(_addressSuggestions[index][LatLng]);
                    setState(() {
                      _addressSuggestions.clear();
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
