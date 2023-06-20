import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:quan_ly_rac_app/const.dart';
import 'package:quan_ly_rac_app/services/mqtt.dart';
import 'package:quan_ly_rac_app/widgets/square_device.dart';

import '../utils/color_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.messageReceive,
  }) : super(key: key);
  final List messageReceive;
  @override
  State<HomePage> createState() => _HomePageState();
}

late MqttServerClient client;

class _HomePageState extends State<HomePage> {
  // List messageReceive = [
  //   {
  //     "device_id": 187,
  //     "sensor": 74.6,
  //     "gps": "20.111111/106.111111",
  //     "battery": 60
  //   },
  //   {
  //     "device_id": 204,
  //     "sensor": 74.99,
  //     "gps": "20.111111/106.111111",
  //     "battery": 85
  //   },
  //   {
  //     "device_id": 188,
  //     "sensor": 50.05,
  //     "gps": "20.941982/106.059408",
  //     "battery": 65
  //   },
  //   {
  //     "device_id": 189,
  //     "sensor": 84.98,
  //     "gps": "20.942002/106.058838",
  //     "battery": 35
  //   },
  //   {
  //     "device_id": 190,
  //     "sensor": 54.98,
  //     "gps": "20.942470/106.058866",
  //     "battery": 74
  //   },
  //   {
  //     "device_id": 191,
  //     "sensor": 34.98,
  //     "gps": "20.942476/106.059631",
  //     "battery": 86
  //   },
  //   {
  //     "device_id": 192,
  //     "sensor": 84.98,
  //     "gps": "20.942989/106.059374",
  //     "battery": 56
  //   },
  //   {
  //     "device_id": 193,
  //     "sensor": 94.98,
  //     "gps": "20.942996/106.058755",
  //     "battery": 52
  //   },
  //   {
  //     "device_id": 194,
  //     "sensor": 54.98,
  //     "gps": "20.942766/106.060375",
  //     "battery": 74
  //   },
  //   {
  //     "device_id": 195,
  //     "sensor": 34.98,
  //     "gps": "20.943433/106.059692",
  //     "battery": 95
  //   },
  //   {
  //     "device_id": 196,
  //     "sensor": 24.98,
  //     "gps": "20.941967/106.060451",
  //     "battery": 63
  //   },
  //   {
  //     "device_id": 197,
  //     "sensor": 94.98,
  //     "gps": "20.941747/106.060043",
  //     "battery": 50
  //   },
  // ];
  //
  // List widget.deviceID = [];

  // mqttConnect() async {
  //   client = MqttServerClient(MQTT_HOST, MQTT_CLIENTID);
  //   client.port = MQTT_PORT;
  //   client.keepAlivePeriod = 60;
  //   client.autoReconnect = true;
  //   client.onConnected = onConnected;
  //   client.onDisconnected = onDisconnected;
  //
  //   try {
  //     await client.connect();
  //   } on NoConnectionException catch (e) {}
  //
  //   client.subscribe("DATN10119609_Publish", MqttQos.exactlyOnce);
  //
  //   client.updates
  //       ?.listen((List<MqttReceivedMessage<MqttMessage>> mqttRecievedMessage) {
  //     final recMess = mqttRecievedMessage[0].payload as MqttPublishMessage;
  //     var payload =
  //         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
  //
  //     final data = json.decode(payload);
  //   });
  // }
  //
  // void onConnected() {
  //   print("onConnected MQTT");
  // }
  //
  // void onDisconnected() {
  //   print("onDisconnected MQTT");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // mqttConnect();
    ConnectMQTT();
  }

  @override
  Widget build(BuildContext context) {
    List deviceID = [];
    for (var index in widget.messageReceive) {
      int id = index["device_id"];
      // double sensor = index["sensor"];
      // String gps = index["gps"];
      // int battery = index["battery"];

      deviceID.add(id);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("6AA84F"),
          hexStringToColor("7CADFF"),
          hexStringToColor("448AFF"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: ListView.builder(
          itemCount: deviceID.length,
          itemBuilder: (context, index) {
            return MySquareDevice(
              idDevice: deviceID[index].toString(),
              valueSensor: widget.messageReceive[index]["sensor"],
              gps: widget.messageReceive[index]["gps"],
              valueBattery: widget.messageReceive[index]["battery"],
            );
          },
        ),
      ),
    );
  }

  void ConnectMQTT() async {
    client = MqttServerClient(MQTT_HOST, MQTT_CLIENTID);
    client.port = MQTT_PORT;
    client.logging(on: true);
    client.keepAlivePeriod = 30;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(MQTT_CLIENTID)
        .keepAliveFor(30)
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;
    try {
      await client.connect("", "");
    } catch (e) {
      _disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      setState(() {
        client.subscribe("DATN10119609_Publish", MqttQos.exactlyOnce);
      });
    } else {
      _disconnect();
      print("connection failed, state is ${client.connectionStatus}");
    }
    client.updates?.listen(_onMessage);
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Map<String, dynamic> dataJson = jsonDecode(message);

    setState(() {
      for (int i = 0; i < widget.messageReceive.length; i++) {
        if (widget.messageReceive[i]["device_id"] == dataJson["device_id"]) {
          widget.messageReceive[i] = dataJson;
          break;
        }
      }
    });

    // print(widget.messageReceive);
  }

  void _disconnect() {
    client.disconnect();
  }
}
