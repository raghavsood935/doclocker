import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpInfo extends StatefulWidget {
  const HelpInfo({Key? key}) : super(key: key);

  @override
  State<HelpInfo> createState() => _HelpInfoState();
}

class _HelpInfoState extends State<HelpInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "About Us !",
            style: TextStyle(
              fontFamily: GoogleFonts.lato().fontFamily,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 70,
            ),
            Image.asset("images/about2.png", fit: BoxFit.cover),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.black,
                width: 1.5, // Underline thickness
              ))),
              child: Text(
                "IIY Software Private Limited",
                style: TextStyle(
                  fontFamily: GoogleFonts.lato().fontFamily,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "OFFICES:- PUNE - MOHALI - BATHINDA",
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Email:- hr@iiysoftware.com",
              style: TextStyle(
                fontFamily: GoogleFonts.lato().fontFamily,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ));
  }
}
