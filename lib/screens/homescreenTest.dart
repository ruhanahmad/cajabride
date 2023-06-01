import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreens extends StatefulWidget {
  @override
  _HomeScreensState createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  late GoogleMapController mapController;

  // @override
  // void initState() {
  //   super.initState();
  //   mapController = 
  //   GoogleMapController(
  //     initialCameraPosition: CameraPosition(
  //       target: LatLng(-34.397, 150.644),
  //       zoom: 15,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              // Replace with your actual Google Map implementation
              initialCameraPosition: CameraPosition(
                target: LatLng(37.422, -122.084),
                zoom: 14.0,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'From',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'To',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
