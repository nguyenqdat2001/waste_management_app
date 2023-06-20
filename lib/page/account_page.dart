import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_rac_app/screens/signin_screen.dart';
import 'package:quan_ly_rac_app/widgets/edit_profile_dialog.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _idText = '';
  String _nameText = "Loading...";
  String _mailText = "Loading...";
  String _phoneText = "Loading...";

  List<String> docIDs = [];

  final _auth = FirebaseAuth.instance;
  late String userEmail;

  void getCurrentUserEmail() async {
    final user = _auth.currentUser?.email;
    userEmail = user!;
    getDocID(userEmail);
  }

  Future<void> getDocID(String mail) async {
    final db = FirebaseFirestore.instance.collection("users");
    await db.where('mail', isEqualTo: userEmail).get().then((value) {
      for (var doc in value.docs) {
        _idText = doc.id;
        var res = doc.data() as Map;
        setState(() {
          _nameText = res['name'];
          _phoneText = res['phone'];
          _mailText = res['mail'];
        });
      }
    });
    // final snapshot = await db.doc("Rtynok6upeK7aVmcEN1E").get();
    // var res = snapshot.data() as Map;
    // setState(() {
    //   _nameText = res['name'];
    //   _phoneText = res['phone'];
    //   _mailText = res['mail'];
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserEmail();
    // getDocID();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("30cb28"),
        hexStringToColor("46dbdb"),
        hexStringToColor("4056e6"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              viewTextField(
                _nameText,
                Icons.person,
                false,
              ),
              const SizedBox(
                height: 20,
              ),
              viewTextField(
                _phoneText,
                Icons.call,
                false,
              ),
              const SizedBox(
                height: 20,
              ),
              viewTextField(
                _mailText,
                Icons.email_outlined,
                false,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return Colors.white;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return EditProfileDialog(
                          name: _nameText,
                          phone: _phoneText,
                          mail: _mailText,
                          idUser: _idText,
                        );
                      }).then((value) {
                    setState(() {
                      getCurrentUserEmail();
                    });
                  });
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return Colors.white;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: const Text(
                  'Sign out',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
