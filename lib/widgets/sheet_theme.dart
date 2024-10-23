import 'package:flutter/material.dart';

class SheetTheme extends StatelessWidget {
  const SheetTheme({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    ThemeData baseTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'GoogleSans',
    );

    return Theme(
      data: baseTheme,
      child: child,
    );
  }
}
