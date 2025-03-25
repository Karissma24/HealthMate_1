/* 
import 'dart:async';
//import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'constants.dart';


class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({Key? key}) : super(key:key);

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  final Completer<GoogleMapController> _controller = Completer();


  static const LatLng myCurrentLocation = LatLng(33.24434, -95.90626);
  static const LatLng destination = LatLng(33.143660034628496, -96.12316134710927);

List<LatLng> polylineCoordinates = []; 

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleApiKey,
    PointLatLng(myCurrentLocation.latitude, myCurrentLocation.longitude),
    PointLatLng(destination.latitude, destination.longitude),
  );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng points)=> 
        polylineCoordinates.add(
          LatLng(points.latitude,points.longitude),
          ),
        );
        setState(() {
          
        });
    };

  }

  void initState(){
    getPolyPoints();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hospital Near Me",
          style: TextStyle(color: Colors.black,fontSize: 16),
        )
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 13.5,
          ),
          polylines: {
            Polyline(polylineId: PolylineId('route'),
            points: polylineCoordinates,
           ),
          },
          markers: {
            const Marker(
              markerId: MarkerId("My Current Location"),
              position: myCurrentLocation,
            ),

            const Marker(
              markerId: MarkerId("Destination"),
              position: destination,
            ),
          },
        ),
    );
    
  }
}
 */