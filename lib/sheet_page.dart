import 'package:flutter/material.dart';
import 'package:sheets/sheet.dart';
import 'package:sheets/sheet_widget.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FlexibleSheet(),
    );
  }
}