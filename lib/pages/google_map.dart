import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng? myCurrentLocation;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  double _currentZoom = 14.0;

  final String googleApiKey = 'AIzaSyDMo7cE18lLqqnulIKutDxbOcpRRUj1ekw';

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    try {
      Position position = await _getCurrentPosition();
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        myCurrentLocation = userLocation;
      });

      _addUserMarker(userLocation);
      await _fetchNearbyHospitals(userLocation);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _refreshLocationAndHospitals() async {
    try {
      Position position = await _getCurrentPosition();
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLocation, zoom: _currentZoom),
        ),
      );

      setState(() {
        markers.clear();
      });

      _addUserMarker(userLocation);
      await _fetchNearbyHospitals(userLocation);
    } catch (e) {
      print("Error refreshing location: $e");
    }
  }

  void _addUserMarker(LatLng position) {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("user_location"),
          position: position,
          infoWindow: const InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    });
  }

  Future<void> _fetchNearbyHospitals(LatLng location) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${location.latitude},${location.longitude}'
        '&radius=40233' // ~25 miles
        '&type=hospital'
        '&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      print('✅ Found ${results.length} hospitals');

      setState(() {
        for (var place in results) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final name = place['name'];

          markers.add(
            Marker(
              markerId: MarkerId(place['place_id']),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: name,
                onTap: () async {
                  final Uri mapsAppUrl = Uri.parse(
                    'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving',
                  );
                  final Uri browserUrl = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1'
                    '&origin=${myCurrentLocation!.latitude},${myCurrentLocation!.longitude}'
                    '&destination=$lat,$lng'
                    '&travelmode=driving',
                  );

                  if (await canLaunchUrl(mapsAppUrl)) {
                    await launchUrl(
                      mapsAppUrl,
                      mode: LaunchMode.externalApplication,
                    );
                  } else if (await canLaunchUrl(browserUrl)) {
                    await launchUrl(
                      browserUrl,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    print('❌ Could not launch directions.');
                  }
                },
              ),
            ),
          );
        }
      });
    } else {
      print('❌ Places API error: ${response.body}');
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          myCurrentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    markers: markers,
                    onMapCreated: (controller) {
                      googleMapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: myCurrentLocation!,
                      zoom: _currentZoom,
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 50,
                    left: 10,
                    child: FloatingActionButton(
                      heroTag: "backBtn",
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),

                  // Zoom In
                  Positioned(
                    bottom: 170,
                    right: 10,
                    child: FloatingActionButton(
                      heroTag: "zoomIn",
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _currentZoom += 1;
                        googleMapController.animateCamera(
                          CameraUpdate.zoomTo(_currentZoom),
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),

                  // Zoom Out
                  Positioned(
                    bottom: 120,
                    right: 10,
                    child: FloatingActionButton(
                      heroTag: "zoomOut",
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _currentZoom -= 1;
                        googleMapController.animateCamera(
                          CameraUpdate.zoomTo(_currentZoom),
                        );
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ),
                ],
              ),

      // Recenter Button
      floatingActionButton: FloatingActionButton(
        heroTag: "recenter",
        backgroundColor: Colors.white,
        onPressed: _refreshLocationAndHospitals,
        child: const Icon(Icons.my_location, color: Colors.purple),
      ),
    );
  }
}
