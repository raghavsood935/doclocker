import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_docsaver/Pages/nameimage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class UploadImage extends StatefulWidget {
  String pathPDF = "";
  UploadImage({required this.pathPDF});
  @override
  _UploadImageState createState() => _UploadImageState(pathPDF: pathPDF);
}

class _UploadImageState extends State<UploadImage> {
  User? user = FirebaseAuth.instance.currentUser;
  Future<List<Map<String, dynamic>>>? future;
  UserModel loggedInUser = UserModel();
  String pathPDF = "";
  _UploadImageState({required this.pathPDF});
  FirebaseStorage storage = FirebaseStorage.instance;
  final myController = TextEditingController();
  bool isLoading = false;
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
      future = _loadImages();
      setState(() {});
    });
    if (pathPDF != "") {
      _upload(pathPDF);
      Fluttertoast.showToast(
          msg: "Select Your Image ! ", toastLength: Toast.LENGTH_SHORT);
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
          allowedExtensions: [
            'jpg',
            'jpeg',
            'png',
          ]);
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
            .child("/images")
            .child("/${name}.${fileextension.toLowerCase()}")
            .putFile(
                fileForFirebase,
                SettableMetadata(customMetadata: {
                  'got_file': '$name',
                  'file_info': '$fileextension' + " Date-$newdate"
                }));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UploadImage(pathPDF: "")));
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

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage
        .ref()
        .child("${loggedInUser.uid}")
        .child("/images")
        .child("/")
        .list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "got_file": fileMeta.customMetadata?['got_file'] ?? 'Got Nothing',
        "file_info": fileMeta.customMetadata?['file_info'] ?? 'No file_info'
      });
    });
    return files;
  }

  Future<List<Map<String, dynamic>>> _SortByDate() async {
    Fluttertoast.showToast(
        msg: "Arranging Files..", toastLength: Toast.LENGTH_SHORT);
    List<Map<String, dynamic>> files = [];
    Fluttertoast.showToast(
        msg: "Please Wait...", toastLength: Toast.LENGTH_SHORT);
    final ListResult result = await storage
        .ref()
        .child("${loggedInUser.uid}")
        .child("/images")
        .child("/")
        .list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "got_file": fileMeta.customMetadata?['got_file'] ?? 'Got Nothing',
        "file_info": fileMeta.customMetadata?['file_info'] ?? 'No file_info'
      });
    });
    if (files.length > 1) {
      int lengthOfArray = files.length;
      for (int i = 0; i < lengthOfArray - 1; i++) {
        String a = files[i]["got_file"];
        String b = files[i + 1]["got_file"];
        for (int j = 0; j < lengthOfArray - i - 1; j++) {
          if (a.compareTo(b) > 0) {
            // Swapping using temporary variable
            var temp = files[j];
            files[j] = files[j + 1];
            files[j + 1] = temp;
          }
        }
      }
    }
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => UploadImage(pathPDF: "")));
    });
    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    Fluttertoast.showToast(
        msg: "File Deleted Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 15.0);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UploadImage(
                  pathPDF: "",
                )));
    setState(() {});
  }

  AlertBox(String ref) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.deepPurple, width: 1.5)),
      title: Text(
        "Are You Sure?",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 22),
      ),
      content: Text(
        "This File Will Be Deleted",
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyText1, fontSize: 15),
      ),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            _delete(ref);
          },
          style: ButtonStyle(
            side:
                MaterialStateProperty.all(BorderSide(color: Colors.deepPurple)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
          ),
          child: Text(
            "Yes, Delete !",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
            side:
                MaterialStateProperty.all(BorderSide(color: Colors.deepPurple)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
          ),
          child: Text(
            "No",
            style: TextStyle(color: Colors.deepPurple),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ShareFiles(String path) {
    Share.shareFiles(['$path']);
  }

  void _showPopupMenu() async {
    await showMenu(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(200, 100, 30, 100),
      items: [
        PopupMenuItem<String>(
          child: TextButton(
            child: Text(
              'Sort By Name',
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 15),
            ),
            style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              _SortByDate();
            },
          ),
          value: '',
        ),
        PopupMenuItem<String>(
          child: TextButton(
            child: Text(
              'Sort By Date',
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 15),
            ),
            style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              _SortByDate();
            },
          ),
          value: '',
        ),
      ],
      elevation: 8.0,
    );
  }

  String search = "";
  Icon closeIcon = new Icon(Icons.close);
  Icon searchIcon = new Icon(Icons.search);
  // ignore: unnecessary_new
  Widget appBarTitle = new Text(
    "Your Images",
    style: TextStyle(
        fontFamily: GoogleFonts.lato().fontFamily,
        fontSize: 20,
        color: Colors.white),
  );

  Future<Null> urlFileShare(String url, String name, String extension) async {
    final RenderObject? box = context.findRenderObject();
    if (Platform.isAndroid) {
      var response = await http.get(Uri.parse(url));
      final documentDirectory = (await getExternalStorageDirectory())!.path;
      File imgFile = new File('$documentDirectory/$name.$extension');
      imgFile.writeAsBytesSync(response.bodyBytes);
      Share.shareFiles(["$documentDirectory/$name.$extension"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: searchIcon,
              onPressed: () {
                setState(() {
                  if (searchIcon.icon == Icons.search) {
                    searchIcon = Icon(Icons.close);
                    appBarTitle = SizedBox(
                      height: 50,
                      child: TextField(
                        cursorColor: Colors.deepPurple,
                        style: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        controller: myController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.deepPurple),
                          hintText: "SEARCH !",
                          hintStyle: TextStyle(
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontSize: 15,
                              color: Colors.deepPurple),
                        ),
                      ),
                    );
                  } else {
                    searchIcon = Icon(Icons.search);
                    appBarTitle = Text(
                      "Your Images",
                      style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontSize: 20,
                          color: Colors.white),
                    );
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: 'Updating List Please Wait',
                    toastLength: Toast.LENGTH_SHORT);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadImage(
                              pathPDF: "",
                            )));
                setState(() {});
              },
            ),
            IconButton(
                onPressed: () {
                  _showPopupMenu();
                },
                icon: Icon(Icons.sort))
          ],
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: future,
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image =
                              snapshot.data![index];
                          String name = image["path"].toString();
                          String ext = name.split(".").last.toLowerCase();
                          Image img = Image.network(image["url"]);
                          return image["got_file"].toString().contains(search)
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OpenImage(
                                                  pathImage: image['url'],
                                                )));
                                  },
                                  child: SizedBox(
                                    height: 90,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: ListTile(
                                        leading: Image.network(
                                          image['url'],
                                          height: 60,
                                          width: 60,
                                        ),
                                        title: Text(image['got_file'],
                                            style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontSize: 17)),
                                        subtitle: Text(image['file_info'],
                                            style: TextStyle(
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                                fontSize: 13)),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Wait getting Share Options",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                                urlFileShare(image["url"],
                                                    image["got_file"], ext);
                                              },
                                              icon: Icon(Icons.share),
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                AlertBox(image['path']);
                                              },
                                              icon: Icon(Icons.delete),
                                              color: Colors.deepPurpleAccent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(100, 100, 5, 10),
          child: SizedBox(
            height: 65,
            width: 65,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(35)),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => NameYourImage()));
              },
            ),
          ),
        ));
  }
}

class OpenImage extends StatefulWidget {
  String pathImage = "";
  OpenImage({required this.pathImage});

  @override
  State<OpenImage> createState() => _OpenImageState(pathImage: pathImage);
}

class _OpenImageState extends State<OpenImage> {
  String _version = "Unknown";
  String pathImage = "";
  bool isLoading = false;
  _OpenImageState({required this.pathImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        //view PDF
        appBar: AppBar(
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
        body: Center(
          child: Container(
            child: Image.network(pathImage),
            height: double.infinity,
            width: double.infinity,
          ),
        ));
  }
}
