import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class circular_widget extends StatelessWidget {
  String LabelText = "";
  String ImagePath = "";
  Widget builder;
  // Function router();

  circular_widget(
      {required this.LabelText,
      required this.ImagePath,
      required this.builder});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("pressed");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => builder),
        );
      },
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(65),
        ),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(65),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: Image.asset(
                  ImagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
