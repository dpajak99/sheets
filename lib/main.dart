import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheets/sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData baseTheme = ThemeData(brightness: Brightness.light);

    return MaterialApp(
      title: 'Sheet App',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
      ),
      home: const SheetPage(),
    );
  }
}