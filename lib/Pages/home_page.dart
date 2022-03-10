import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_docsaver/Upload/docs_pdf.dart';
import 'package:flutter_docsaver/account_pages/logoutpage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Upload/image.dart';
import 'aboutus.dart';
import '../model/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  static const snackBarDuration = Duration(seconds: 3);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  FirebaseStorage storage = FirebaseStorage.instance;
  final snackBar = SnackBar(
    content: Text('Press back again to leave'),
    duration: HomePage.snackBarDuration,
  );

  late DateTime backButtonPressTime;
  List pages = [HomePage(), LogoutPage()];
  int currentIndex = 0;
  int homeIndex = 0;

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
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => pages[currentIndex]));
    }
    if (currentIndex == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => pages[currentIndex]));
    }
  }

  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime) > HomePage.snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => handleWillPop(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white30,
          showUnselectedLabels: false,
          onTap: onTap,
          currentIndex: homeIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.logout), label: 'Logout'),
          ],
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Doc Locker ",
              style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w400)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.help,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpInfo()),
                  );
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0x00C52121),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 800,
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(
                            height: 20,
                            thickness: 2,
                            indent: 120,
                            endIndent: 120,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            "Store Your Valuables!",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                color: Colors.deepPurple),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MenuButton(
                                labelText: 'DOCS',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UploadPDF(
                                                pathPDF: "",
                                              )));
                                },
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              MenuButton(
                                  labelText: 'IMAGES',
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UploadImage(
                                                  pathPDF: "",
                                                )));
                                  })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//menu button widget

class MenuButton extends StatelessWidget {
  // const MenuButton({
  //   Key? key,
  // }) : super(key: key);
  String labelText;
  void Function()? onPressed;
  MenuButton({required this.labelText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(65.0),
      ),
      child: MaterialButton(
        elevation: 10,
        onPressed: onPressed,
        child: Text(
          labelText,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyText1,
              fontSize: 18,
              // fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }
}
