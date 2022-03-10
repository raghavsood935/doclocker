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
            "About Me !",
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
                "Raghav ",
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
              "Working As a - Software Developer",
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
              "Email:- raghavsood111@gmail.com",
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
