import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quan_ly_rac_app/page/main_page.dart';
import 'package:quan_ly_rac_app/screens/signin_screen.dart';
import 'package:quan_ly_rac_app/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DATN 2023',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

// class Mapp extends StatefulWidget {
//   const Mapp({Key? key}) : super(key: key);
//
//   @override
//   State<Mapp> createState() => _MappState();
// }
//
// class _MappState extends State<Mapp> {
//   GoogleMapController? myMapController;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mapp"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(-33.870840, 151.206286),
//               zoom: 12,
//             ),
//             mapType: MapType.normal,
//             onMapCreated: (controller) {
//               setState(() {
//                 myMapController = controller;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
