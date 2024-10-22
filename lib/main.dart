import 'package:flutter/material.dart';
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
      fontFamily: 'Arial',
    );

    return MaterialApp(
      title: 'Sheet App',
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      home: const SheetPage(),
    );
  }
}
