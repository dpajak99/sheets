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
    ThemeData baseTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'GoogleSans',
    );

    return MaterialApp(
      title: 'Sheet App',
      theme: baseTheme,
      debugShowCheckedModeBanner: false,
      home: const SheetPage(),
    );
  }
}
