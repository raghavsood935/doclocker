import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_docsaver/Pages/home_page.dart';
import 'package:flutter_docsaver/account_pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(
    MaterialApp(home: email == null ? SplashToLogin() : SplashToHomePage()),
  );
}

class SplashToLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            fontFamily: GoogleFonts.lato().fontFamily),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: AnimatedSplashScreen(
          nextScreen: LoginPage(),
          splash: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Image.asset(
                "images/logo.png",
                height: 110,
                width: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Text("Doc Locker",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontFamily: GoogleFonts.lato().fontFamily)),
              ),
            ],
          ),
          splashIconSize: 300,
          backgroundColor: Color.fromARGB(16, 16, 16, 16),
          splashTransition: SplashTransition.slideTransition,
          duration: 2500,
        ));
  }
}

class SplashToHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeMode: ThemeMode.light,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            fontFamily: GoogleFonts.lato().fontFamily),
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: AnimatedSplashScreen(
          nextScreen: HomePage(),
          splash: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Image.asset(
                "images/logo.png",
                height: 110,
                width: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Text("Doc Locker",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontFamily: GoogleFonts.lato().fontFamily)),
              ),
            ],
          ),
          splashIconSize: 300,
          backgroundColor: Color.fromARGB(16, 16, 16, 16),
          splashTransition: SplashTransition.slideTransition,
          duration: 2500,
        ));
  }
}
