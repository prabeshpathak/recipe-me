import 'package:flutter/material.dart';
import 'package:recipe_app_flutter/pages/SignUp.dart';
import 'package:recipe_app_flutter/pages/WelcomePage.dart';
import "package:google_fonts/google_fonts.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: WelcomePage(),
    );
  }
}
