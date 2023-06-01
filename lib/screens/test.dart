// import 'package:cajabride/controller/userController.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

// import 'homeScreen.dart';

// class PickupLocationScreen extends StatefulWidget {
//   @override
//   _PickupLocationScreenState createState() => _PickupLocationScreenState();
// }

// class _PickupLocationScreenState extends State<PickupLocationScreen> {
//   UserController userController  = Get.put(UserController());
//   TextEditingController _locationController = TextEditingController();
//   PickResult? _selectedPlace;

//   @override
//   void dispose() {
//     userController.locationControllerTwo.dispose();
//     super.dispose();
//   }

//   void _onPlacePickerResult(PickResult result) async {
//     _selectedPlace = result;
//     print(_selectedPlace!.formattedAddress);

//     if (_selectedPlace != null) {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _selectedPlace!.geometry!.location.lat,
//         _selectedPlace!.geometry!.location.lng,
//       );
//      userController.searchText  =   _selectedPlace!.formattedAddress;

//       if (placemarks != null && placemarks.isNotEmpty) {
//         Placemark placemark = placemarks[0];
//         String address = placemark.name! + ', ' + placemark.locality!;
//         // userController.searchText = address;
//         // userController.update();
//         // print("object=============================================");
//         // print(userController.searchText);
//       }
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         title: Text('Pickup Location'),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Get.to(HomePage());
//             },
//             child: Text("Ok",style: TextStyle(color: Colors.white,fontSize: 20),))
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PlacePicker(
//               apiKey: 'AIzaSyCZJDq4ZZiah_srzkzjQDtxnXVE-gbf85M',
//               initialPosition: LatLng(37.422, -122.084),
//               useCurrentLocation: true,
//               onPlacePicked: _onPlacePickerResult,
//               // searchingText: userController.locationController.text,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextFormField(
//               controller: userController.locationControllerTwo,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Location',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
