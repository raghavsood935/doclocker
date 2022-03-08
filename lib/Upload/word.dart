import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_docsaver/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:open_file/open_file.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:share/share.dart';

import '../model/user_model.dart';
import 'docs_pdf.dart';

class UploadWord extends StatefulWidget {
  String pathPDF = "";
  UploadWord({required this.pathPDF});
  @override
  _UploadWordState createState() => _UploadWordState(pathPDF: pathPDF);
}

class _UploadWordState extends State<UploadWord> {
  String pathPDF = "";
  _UploadWordState({required this.pathPDF});
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  FirebaseStorage storage = FirebaseStorage.instance;
  var path, a, b, c;
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
          allowedExtensions: ['doc', 'docx']);
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
      Fluttertoast.showToast(
          msg: "Refreshing List Please Wait", toastLength: Toast.LENGTH_SHORT);
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
