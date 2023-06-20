import 'package:flutter/material.dart';
import 'package:quan_ly_rac_app/page/account_page.dart';
import 'package:quan_ly_rac_app/page/home_page.dart';
import 'package:quan_ly_rac_app/page/map_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabMain(),
    );
  }
}

class TabMain extends StatefulWidget {
  const TabMain({Key? key}) : super(key: key);

  @override
  State<TabMain> createState() => _TabMainState();
}

// { "device_id": 187,"sensor": 84.98,"gps": "20.942249/106.059653","battery": 35}
// { "device_id": 204,"sensor": 56.8,"gps": "20.942249/106.059599","battery": 56}
List messageReceive = [
  {
    "device_id": 187,
    "sensor": 7.6,
    "gps": "20.942259/106.059584",
    "battery": 60
  },
  {
    "device_id": 204,
    "sensor": 7.99,
    "gps": "20.942252/106.059541",
    "battery": 85
  },
  {
    "device_id": 188,
    "sensor": 5.6,
    "gps": "20.941982/106.059408",
    "battery": 65
  },
  {
    "device_id": 189,
    "sensor": 3.9,
    "gps": "20.942002/106.058838",
    "battery": 35
  },
  {
    "device_id": 190,
    "sensor": 7.8,
    "gps": "20.942470/106.058866",
    "battery": 74
  },
  {
    "device_id": 191,
    "sensor": 4.8,
    "gps": "20.942476/106.059631",
    "battery": 86
  },
  {
    "device_id": 192,
    "sensor": 8.8,
    "gps": "20.942989/106.059374",
    "battery": 56
  },
  {
    "device_id": 193,
    "sensor": 9.0,
    "gps": "20.942996/106.058755",
    "battery": 52
  },
  {
    "device_id": 194,
    "sensor": 5.98,
    "gps": "20.942766/106.060375",
    "battery": 74
  },
  {
    "device_id": 195,
    "sensor": 3.9,
    "gps": "20.943433/106.059692",
    "battery": 95
  },
  {
    "device_id": 196,
    "sensor": 2.8,
    "gps": "20.941967/106.060451",
    "battery": 63
  },
  {
    "device_id": 197,
    "sensor": 9.9,
    "gps": "20.941747/106.060043",
    "battery": 50
  },
];

class _TabMainState extends State<TabMain> {
  List pages = [
    HomePage(messageReceive: messageReceive),
    MapPage(messageReceive: messageReceive),
    AccountPage()
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
