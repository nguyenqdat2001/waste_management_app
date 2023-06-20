import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String deviceID;
  String sensor;
  String gps;
  String battery;

  Message(
      {required this.deviceID,
      required this.sensor,
      required this.gps,
      required this.battery});
}

class User {
  final String? id;
  final String name;
  final String phone;
  final String mail;

  const User(
      {this.id, required this.name, required this.phone, required this.mail});

  toJson() {
    return {
      "mail": mail,
      "name": name,
      "phone": phone,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
        id: document.id,
        mail: data["mail"],
        name: data['name'],
        phone: data['phone']);
  }
}
