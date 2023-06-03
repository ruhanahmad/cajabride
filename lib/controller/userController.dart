import 'dart:async';
import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  TextEditingController locationController = TextEditingController();
  TextEditingController locationControllerTwo = TextEditingController();
    String? searchText;
      Completer<GoogleMapController> completerss = Completer();
  Set<Polygon> polygons = Set<Polygon>();
    Set<Polyline> polyline = Set<Polyline>();
    List<LatLng> polygonsLatLng = <LatLng>[];
    Set<Marker> markers = Set<Marker>(); 
       int polygonCounter = 1;
    int polylineCounter = 1;

                 Future<Map<String,dynamic>> getDirections()async {
              
               
      
 String url =
        'https://maps.googleapis.com/maps/api/directions/json' +
            '?origin=paris' +
            '&destination=germany' +
            '&key=AIzaSyCZJDq4ZZiah_srzkzjQDtxnXVE-gbf85M';
            var response = await http.get(Uri.parse(url));
            var jason = jsonDecode(response.body);
            print(jason);
            var results = {
               'bounds_ne':jason["routes"][0]['bounds']['northeast'],
               'bounds_sw':jason["routes"][0]['bounds']['southwest'],

               'start_location':jason["routes"][0]['legs'][0]['start_location'],
               'end_location':jason["routes"][0]['legs'][0]['end_location'],
               'polyline':jason["routes"][0]['overview_polyline']['points'],
               'polyline_decoded':PolylinePoints().decodePolyline(jason["routes"][0]['overview_polyline']['points']),

            };
             print(results);
            return results;
              }

                       Future<void>    goToPlace(double lat,double lng,
          Map<String,dynamic> boundsNe,
          Map<String,dynamic> boundsSw,

          
          )async{
          
          final GoogleMapController controller = await completerss.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng),zoom: 12),
            
            ));
            
          controller.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(boundsSw["lat"], boundsSw["lng"]), 
              northeast: LatLng(boundsNe["lat"], boundsNe["lng"]), ),25
            )
            
            );

      setMarkers(LatLng(lat, lng));
              }

                            setMarkers(LatLng points) {

   markers.add(Marker(markerId: MarkerId('marker'),
   position: points
   
   ),
   
   );
   update();

              }

                 void setPolygon()async {
final  polygonIdVal = "polygon_$polygonCounter";
polygonCounter ++;

 Polygon(
  polygonId: PolygonId(polygonIdVal),
  points: polygonsLatLng,
  strokeWidth: 2,
  fillColor: Colors.blue
 
 );
    }
    void setPolyline(List<PointLatLng> points)async {
final String  polylineIdVal = "polygon_$polylineCounter";
polylineCounter ++;

polyline.add( Polyline(
  polylineId: PolylineId(polylineIdVal),
 
 width: 2,
 color: Colors.blue,
 points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
 
 ));

    }
    List<dynamic> _addressSuggestions = [];
      void _getAddressSuggestions(String input) async {
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json' +
        '?input=$input' +
        '&types=address' +
        '&key=AIzaSyCZJDq4ZZiah_srzkzjQDtxnXVE-gbf85M';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final predictions = jsonData['predictions'];

  
        _addressSuggestions = predictions
            .map((prediction) => prediction['description'])
            .toList();
     update();
      
    }
  }
   showModalBottomSheet(){
   



              return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return 
            
             Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              TextFormField(
                controller: locationController,
                onChanged: _getAddressSuggestions,
                decoration: InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _addressSuggestions.length,
                  itemBuilder: (context, index) {

                    return ListTile(
                      title: 
                    
                      Text(_addressSuggestions[index]),
                      onTap: () async {
                      locationController.text = _addressSuggestions[index];
                            //  LatLng latLngs = await fetchLatLng(userController.locationController.text);
                            // _moveToLocation(latLngs);
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
                       await    getDirections();
                        }
                      
                   
                          _addressSuggestions.clear();
                    update();
                      },
                    );
                  },
                ),
              ),
             
            ],
          ),
        ),
      );
          },
        );
      

   
    }
 
   }
   
