import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quan_ly_rac_app/widgets/map_dialog.dart';

class MySquareDevice extends StatelessWidget {
  const MySquareDevice(
      {Key? key,
      required this.idDevice,
      required this.valueSensor,
      required this.gps,
      required this.valueBattery})
      : super(key: key);

  final String idDevice;
  final double valueSensor;
  final String gps;
  final int valueBattery;

  @override
  Widget build(BuildContext context) {
    List<int> _valueTrash = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
    getValueTrash() {
      int v = valueSensor.toInt();
      if (v >= 10) {
        return _valueTrash[10];
      } else if (v < 10.0) {
        return _valueTrash[v] * 10;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return MapDialog(
                    valueSensor: valueSensor,
                    valueBattery: valueBattery,
                    gps: gps,
                  );
                });
          },
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                title: Text(
                  "ID: ${idDevice}",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                subtitle: Text(
                  "Location: ${gps}",
                  style: TextStyle(color: Colors.black45),
                ),
                trailing: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Trash: ${getValueTrash()} %",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "Battery: ${valueBattery} %",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
