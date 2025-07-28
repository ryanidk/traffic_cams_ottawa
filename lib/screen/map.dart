import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trafficcamerasottawa_new/screen/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trafficcamerasottawa_new/camera_list.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> markerList = Set();
  late GoogleMapController mapControl;
  LatLng _currentPos = LatLng(45.42472, -75.69500);
  bool _isLoading = true;
  LatLngBounds boundary = LatLngBounds(
    southwest: const LatLng(44.8988, -76.2486), // Example coordinates
    northeast: const LatLng(46.1185, -74.5962),
  );

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      double lat = position.latitude;
      double long = position.longitude;
      LatLng location = LatLng(lat, long);

      setState(() {
        _currentPos = location;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void getPage(camraId, caeraName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraScreen(cameraId: camraId, cameraName: caeraName),
      ),
    );
  }

  void getMarkers() {
    for (var camera in cameraList) {
      markerList.add(Marker(
          markerId: MarkerId(camera["name"]),
          position: LatLng(camera["latitude"], camera["longitude"]),
          onTap: () {
            getPage(camera["camera_number"], camera["name"]);
          }));
    }
  }

  void _onMap(GoogleMapController controller) {
    mapControl = controller;
  }

  @override
  Widget build(BuildContext context) {
    getMarkers();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              cameraTargetBounds: CameraTargetBounds(boundary),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              onMapCreated: _onMap,
              initialCameraPosition:
                  CameraPosition(target: _currentPos, zoom: 12),
              markers: markerList,
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getLocation();
            if (_currentPos == LatLng(45.42472, -75.69500)) {
              ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                content: const Text(
                    "Could not get current location. Please check location permission in phone settings."),
                leading: const Icon(Icons.near_me),
                contentTextStyle:
                    const TextStyle(fontSize: 14, color: Colors.black),
                actions: [
                  IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).clearMaterialBanners();
                      },
                      icon: const Icon(Icons.close))
                ],
              ));
            } else {
              await mapControl.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPos, zoom: 12)));
            }
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.near_me,
            color: Colors.white,
          )),
    );
  }
}
