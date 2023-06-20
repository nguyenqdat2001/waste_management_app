import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required this.messageReceive,
  }) : super(key: key);
  final List messageReceive;
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  LatLng myLocation = LatLng(20.941638, 106.059998);
  final Set<Marker> _markers = new Set();

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      myLocation = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(myLocation.toString()),
        position: myLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
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

  List<int> _valueTrash = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
  getValueTrash(valueSensor) {
    int v = valueSensor.toInt();
    if (v >= 10) {
      return _valueTrash[10];
    } else if (v < 10.0) {
      return _valueTrash[v] * 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    List deviceID = [];
    List markerID = [];
    for (var index in widget.messageReceive) {
      int id = index["device_id"];
      // double sensor = index["sensor"];
      String gps = index["gps"];
      // int battery = index["battery"];

      deviceID.add(id);
      markerID.add(gps);
    }
    print(deviceID);
    return Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: myLocation,
          zoom: 20,
        ),
        mapType: MapType.normal,
        markers: myMarker(),
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> myMarker() {
    for (var index in widget.messageReceive) {
      final gpsSplit = index['gps'].split('/');
      LatLng deviceLocation =
          LatLng(double.parse(gpsSplit[0]), double.parse(gpsSplit[1]));
      setState(() {
        _markers.addLabelMarker(LabelMarker(
          textStyle: TextStyle(fontSize: 30),
          label: "${getValueTrash(index['sensor'])}%",
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(deviceLocation.toString()),
          position: deviceLocation,
          infoWindow: InfoWindow(
            title: 'Trash:${getValueTrash(index['sensor'])}%',
            snippet: 'Battery: ${index['battery']}%',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }

    return _markers;
  }
}

// class MapPage extends StatelessWidget {
//   const MapPage({
//     Key? key,
//     required this.messageReceive,
//   }) : super(key: key);
//   final List messageReceive;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(20.941638, 106.059998),
//             zoom: 17,
//           ),
//           mapType: MapType.normal,
//         ),
//       ),
//     );
//   }
// }
