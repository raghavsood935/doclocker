import 'package:flutter/material.dart';
import 'package:flutter_docsaver/Upload/image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_docsaver/Upload/docs_pdf.dart';

class NameYourImage extends StatefulWidget {
  @override
  State<NameYourImage> createState() => _NameYourImageState();
}

class _NameYourImageState extends State<NameYourImage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Image.asset("images/filename.png", fit: BoxFit.cover),
                Text(
                  "Enter the Image Name !",
                  style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: controller,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Enter Name Of File");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Name");
                            }
                          },
                          onSaved: (value) {
                            controller.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'ENTER HERE',
                            labelStyle: TextStyle(
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.deepPurple, width: 1),
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          cursorColor: Colors.deepPurple,
                          style: TextStyle(
                              fontFamily: GoogleFonts.lato().fontFamily,
                              fontSize: 15)),
                      SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: MaterialButton(
                            color: Colors.deepPurple,
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1500));
                              Navigator.pushReplacement(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => UploadImage(
                                            pathPDF: controller.text,
                                          )));
                            },
                            child: (isLoading)
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ))
                                : Text(
                                    'S A V E',
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    "SAVE to Pick Image from Storage!",
                    style: TextStyle(
                      fontFamily: GoogleFonts.lato().fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
