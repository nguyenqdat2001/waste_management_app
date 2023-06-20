import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {
  const MapDialog({
    Key? key,
    required this.valueSensor,
    required this.valueBattery,
    required this.gps,
  }) : super(key: key);
  final double valueSensor;
  final int valueBattery;
  final String gps;

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  GoogleMapController? mapController;
  Set<Marker> _markers = new Set();
  LatLng myLocation = LatLng(20.941638, 106.059998);
  LatLng deviceLocation = LatLng(20.932934, 106.021852);

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      myLocation = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPositionUser =
          CameraPosition(target: myLocation, zoom: 15);
      mapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPositionUser));
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("error Permisstion Location");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Location'),
      content: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myLocation,
          zoom: 17,
        ),
        markers: myMarker(),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
            mapController
                ?.showMarkerInfoWindow(MarkerId(deviceLocation.toString()));
          });
        },
      ),
    );
  }

  List<int> _valueTrash = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  getValueTrash() {
    int v = widget.valueSensor.toInt();
    if (v >= 10) {
      return _valueTrash[10];
    } else if (v < 10.0) {
      return _valueTrash[v] * 10;
    }
  }

  Set<Marker> myMarker() {
    _markers = {};
    final gpsSplit = widget.gps.split('/');
    deviceLocation =
        LatLng(double.parse(gpsSplit[0]), double.parse(gpsSplit[1]));
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(deviceLocation.toString()),
        position: deviceLocation,
        infoWindow: InfoWindow(
          title: 'Trash:${getValueTrash()}%',
          snippet: 'Battery: ${widget.valueBattery}%',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(myLocation.toString()),
        position: myLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });

    return _markers;
  }
}
