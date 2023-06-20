import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quan_ly_rac_app/page/main_page.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _cfPasswordTextController =
      TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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
              children: <Widget>[
                reusableTextField("Enter your name", Icons.person, false,
                    _nameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter your phone number", Icons.call, false,
                    _phoneTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter confirm password", Icons.lock_outline,
                    true, _cfPasswordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  print("day");
                  if (_passwordTextController.text ==
                      _cfPasswordTextController.text) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text.trim())
                        .then((value) {
                      FirebaseFirestore.instance.collection("users").add({
                        'mail': _emailTextController.text.trim(),
                        'name': _nameTextController.text.trim(),
                        'phone': _phoneTextController.text.trim(),
                      });
                      Fluttertoast.showToast(
                        msg: "Created New Account",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.grey[200],
                        textColor: Colors.black,
                        fontSize: 16,
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TabMain()));
                    }).onError((error, stackTrace) {
                      print("Error $error");
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "Passwords do NOT match",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.grey[200],
                      textColor: Colors.black,
                      fontSize: 16,
                    );
                  }
                  print("dayday");
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
