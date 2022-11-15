import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPicker extends StatefulWidget {
  const GoogleMapPicker({super.key});

  @override
  State<GoogleMapPicker> createState() => _GoogleMapPickerState();
}

class _GoogleMapPickerState extends State<GoogleMapPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  // ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(12.679519, 108.044521),
    zoom: 18,
  );
  double? longitude;
  double? latitude;

  Future<Position> getLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      log(error.toString());
    });
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Google Maps',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: (position) {
              latitude = position.target.latitude;
              longitude = position.target.longitude;
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              color: Color.fromARGB(255, 232, 15, 0),
              size: 40,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 70,
            left: 70,
            child: Container(
              height: 56,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  icon: const Icon(FontAwesomeIcons.location),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 8,
                      shape: (RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(130)))),
                  onPressed: () {
                    getLocation().then((value) {
                      longitude = value.longitude;
                      latitude = value.latitude;
                      log(latitude.toString() + "chi" + longitude.toString());
                    });
                  },
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'CHOOCE LOCATION',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
