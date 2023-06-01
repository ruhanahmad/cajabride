import 'dart:async';

import 'package:cajabride/controller/userController.dart';
import 'package:cajabride/screens/selectMap.dart';
import 'package:cajabride/screens/test.dart';
import 'package:cajabride/screens/testthree.dart';
import 'package:cajabride/testtwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController = Get.put(UserController());
    
    LatLng? _selectedLocation;
  TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    userController.locationController.dispose();
    super.dispose();
  }
  Completer<GoogleMapController> _controller = Completer();
  Set<Polygon> _polygons = Set<Polygon>();
    Set<Polyline> _polyline = Set<Polyline>();
    List<LatLng> polygonsLatLng = <LatLng>[];

    int _polygonCounter = 1;
    int _polylineCounter = 1;


    void setPolygon()async {
final  polygonIdVal = "polygon_$_polygonCounter";
_polygonCounter ++;

 Polygon(
  polygonId: PolygonId(polygonIdVal),
  points: polygonsLatLng,
  strokeWidth: 2,
  fillColor: Colors.blue
 
 );
    }
    void setPolyline(List<PointLatLng> points)async {
final String  polylineIdVal = "polygon_$_polylineCounter";
_polylineCounter ++;

_polyline.add( Polyline(
  polylineId: PolylineId(polylineIdVal),
 
 width: 2,
 color: Colors.blue,
 points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
 
 ));

    }


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
   bool _containerVisible = true;

  void _hideContainer() {
    setState(() {
      _containerVisible = false;
    });
  }

  void _showContainer() {
    setState(() {
      _containerVisible = true;
    });
  }
  // Completer <
  static final CameraPosition _cameraPosition = 
CameraPosition(
                target: LatLng(37.422, -122.084),
                zoom: 14.0,

              );

              Future<Map<String,dynamic>> getDirections()async {
 String url =
        'https://maps.googleapis.com/maps/api/directions/json' +
            '?origin=paris' +
            '&destination=france' +
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
          Future<void>    goToPlace(double lat,double lng)async{
          
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng),zoom: 12),
            
            ));

      _setMarker(LatLng(lat, lng));
              }
// 09
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Uber'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu icon press
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications icon press
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
           mapType: MapType.normal,
           myLocationButtonEnabled: true,
           polygons: _polygons,
           polylines: _polyline,
           onMapCreated: (GoogleMapController cgoogle){
             
           },
                     onTap: (_) {
            _showContainer();
          },
          onLongPress: (_) {
            _hideContainer();
          },
           // Replace with your actual Google Map implementation
           initialCameraPosition: CameraPosition(
             target: LatLng(37.422, -122.084),
             zoom: 14.0,

           ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
                opacity: _containerVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child:Container(
                height: 400.0,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a Vehicle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 50.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Replace with your list of vehicle types
                        VehicleCard(
                          image: AssetImage('assets/images/bike.jpg'),
                          title: 'Bike',
                        ),
                        VehicleCard(
                          image: AssetImage('assets/images/car.jpg'),
                          title: 'Car',
                        ),
                        // VehicleCard(
                        //   image: AssetImage('assets/auto.png'),
                        //   title: 'Auto',
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: [
                      Container(
                        height: 50,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "${userController.locationController.text}",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                               onTap: () {
                                Get.to (AddressEntryScreened());
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: Text('Enter Fare'),
          //           content:
          //          Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: TextFormField(
          //     controller: userController.locationController,
          //     readOnly: true,
          //     decoration: InputDecoration(
          //       labelText: 'Location',
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          //           actions: [
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: Text('Cancel'),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 Get.to(SelectMapScreen());
          //                 // Do something with the fare
          //                 // Navigator.pop(context);
          //               },
          //               child: Text('OK'),
          //             ),
          //           ],
          //         );
          //       },
          //     );
            },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "${userController.locationControllerTwo.text}",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                            // onTap: () {
                            //     Get.to (PickupLocationScreen());
                            // },
                        ),
                      ),
                      SizedBox(height: 10,),
                       Center(
          child: Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
                              hintText: 'Enter Fare',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Enter Fare'),
                    content: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter fare',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Do something with the fare
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ),
        ),
          SizedBox(height: 10,),
                      Container(
                        height: 50,
                        
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.green
                        ),
                        child: Center(child: Text("Find Driver",
                        style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),

)),
                      ),
                        IconButton(onPressed:()async{

                var directions =       await  getDirections();


                    goToPlace(directions["start_location"]["lat"],directions["end_location"]["lng"],
                    directions["bounds_ne"],
                    directions["bounds_sw"],
                    
                    
                    );

                    setPolyline(directions["polyline_decoded"]);

                        }, icon: Icon(Icons.ac_unit_outlined)),

                          //  SizedBox(height: 10,),
                         
  
                    ],
                    
                  ),
                ],
              ),
              ),

            
            
            ),
          ),
        ],
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final ImageProvider image;
  final String title;

  const VehicleCard({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      margin: EdgeInsets.only(right: 7.0),
      child: CircleAvatar(backgroundImage: image,));}}
