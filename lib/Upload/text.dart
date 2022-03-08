import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../model/user_model.dart';
import 'docs_pdf.dart';

class UploadText extends StatefulWidget {
  String pathPDF = "";
  UploadText({required this.pathPDF});
  @override
  _UploadTextState createState() => _UploadTextState(pathPDF: pathPDF);
}

class _UploadTextState extends State<UploadText> {
  String pathPDF = "";
  _UploadTextState({required this.pathPDF});
  FirebaseStorage storage = FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  DateTime? now, date;
  String? dateinString;
  int? idx, idx2;
  int track = 0;
  List<dynamic> paths = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    if (pathPDF != "") {
      _upload(pathPDF);
      Fluttertoast.showToast(
          msg: "Select Your Document! ", toastLength: Toast.LENGTH_SHORT);
    }
  }

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String name) async {
    try {
      final result = await FilePicker.platform.pickFiles(
          withReadStream: true,
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['doc', 'txt']);
      if (result == null) return;
      final file = result.files.first;
      paths.add(file.path);
      File fileForFirebase = File(file.path.toString());
      idx = file.name.toString().lastIndexOf(".");
      idx2 = file.path.toString().lastIndexOf("/");
      String fileName = file.name.substring(0, idx).trim();
      String fileextension = file.path!.split(".").last.toUpperCase();
      final now = new DateTime.now();
      String formatter = now.toString();
      idx = formatter.indexOf(" ");
      String newdate =
          formatter.substring(0, idx).split('-').reversed.join("/");
      try {
        // Uploading the selected image with some custom meta data
        await storage
            .ref()
            .child("${loggedInUser.uid}")
            .child("/${name}.${fileextension.toLowerCase()}")
            .putFile(
                fileForFirebase,
                SettableMetadata(customMetadata: {
                  'got_file': '$name',
                  'file_info': '$fileextension' + " Date-$newdate"
                }));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UploadPDF(pathPDF: "")));
        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Text(
            "",
            style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 20,
                color: Colors.white),
          ),
        ]),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(70, 150, 10, 80),
        child: Column(children: [
          SizedBox(
            height: 150,
          ),
          Text(
            'This Page Will Refresh Automatically',
            style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black),
          ),
        ]),
      ),
    );
  }
}
