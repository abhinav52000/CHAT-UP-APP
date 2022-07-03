import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle registrationpagestyle({double? opacity}) => TextStyle(
    color: Colors.white.withOpacity(opacity ?? 1),
    fontSize: 15,
    fontWeight: FontWeight.bold);

TextStyle registrationpagehead = GoogleFonts.concertOne(
    color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400);

OutlineInputBorder registraionpagetilesborder = const OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
  borderSide: BorderSide(color: Colors.white, width: 0),
);

OutlineInputBorder searchscreenpagetilesborder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(color: Colors.white, width: 0),
);

InputDecoration inputDecorationfortextfield() {
  return InputDecoration(
    focusedBorder: registraionpagetilesborder,
    enabledBorder: registraionpagetilesborder,
    hintText: 'Hint text copywith method se bdlo',
    constraints: const BoxConstraints(maxWidth: double.infinity),
    hintStyle: registrationpagestyle(opacity: 0.5),
  );
}

bool hidepassword = true;
bool showspinner = false;
