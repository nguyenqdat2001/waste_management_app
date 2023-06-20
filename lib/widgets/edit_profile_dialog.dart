import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../reusable_widgets/reusable_widget.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    Key? key,
    required this.idUser,
    required this.name,
    required this.phone,
    required this.mail,
  }) : super(key: key);

  final String name;
  final String phone;
  final String mail;
  final String idUser;
  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _nameText = widget.name;
    String _phoneText = widget.phone;
    String _mailText = widget.mail;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Edit Profile',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: [
              TextField(
                controller: _nameTextController,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  labelText: _nameText,
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.grey.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _phoneTextController,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.call,
                    color: Colors.black,
                  ),
                  labelText: _phoneText,
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.grey.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                enabled: false,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.mail,
                    color: Colors.black,
                  ),
                  labelText: _mailText,
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.grey.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.lightGreen;
                    }
                    return Colors.green;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                onPressed: buttonSave,
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buttonSave() async {
    String name = _nameTextController.text;
    String phone = _phoneTextController.text;
    if (name == '') {
      name = widget.name;
    }
    if (phone == '') {
      phone = widget.phone;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.idUser)
        .update({
      'mail': widget.mail,
      'name': name,
      'phone': phone,
    });
    Fluttertoast.showToast(
      msg: "Edit Success",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey[200],
      textColor: Colors.black,
      fontSize: 16,
    );
  }
}
