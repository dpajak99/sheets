import 'package:flutter/material.dart';

class MaterialSheetTheme {
  static const BoxShadow materialShadow = BoxShadow(
    color: Color.fromRGBO(60, 64, 67, 0.15),
    offset: Offset(0, 2),
    blurRadius: 6,
    spreadRadius: 2,
  );

  static const List<int> baseColors = <int>[
    0xFF000000, 0xFF434343, 0xFF666666, 0xFF999999, 0xFFB7B7B7, 0xFFCCCCCC, 0xFFD9D9D9, 0xFFEFEFEF, 0xFFF3F3F3, 0xFFFFFFFF, //
    0xFF980000, 0xFFFF0000, 0xFFFF9900, 0xFFFFFF00, 0xFF00FF00, 0xFF00FFFF, 0xFF4A86E8, 0xFF0000FF, 0xFF9900FF, 0xFFFF00FF, //
    0xFFE6B8AF, 0xFFF4CCCC, 0xFFFCE5CD, 0xFFFFF2CC, 0xFFD9EAD3, 0xFFD0E0E3, 0xFFC9DAF8, 0xFFCFE2F3, 0xFFD9D2E9, 0xFFEAD1DC, //
    0xFFDD7E6B, 0xFFEA9999, 0xFFF9CB9C, 0xFFFFE599, 0xFFB6D7A8, 0xFFA2C4C9, 0xFFA4C2F4, 0xFF9FC5E8, 0xFFB4A7D6, 0xFFD5A6BD, //
    0xFFCC4125, 0xFFE06666, 0xFFF6B26B, 0xFFFFD966, 0xFF93C47D, 0xFF76A5AF, 0xFF6D9EEB, 0xFF6FA8DC, 0xFF8E7CC3, 0xFFC27BA0, //
    0xFFA61C00, 0xFFCC0000, 0xFFE69138, 0xFFF1C232, 0xFF6AA84F, 0xFF45818E, 0xFF3C78D8, 0xFF3D85C6, 0xFF674EA7, 0xFFA64D79, //
    0xFF85200C, 0xFF990000, 0xFFB45F06, 0xFFBF9000, 0xFF38761D, 0xFF134F5C, 0xFF1155CC, 0xFF0B5394, 0xFF351C75, 0xFF741B47, //
    0xFF5B0F00, 0xFF660000, 0xFF783F04, 0xFF7F6000, 0xFF274E13, 0xFF0C343D, 0xFF1C4587, 0xFF073763, 0xFF20124D, 0xFF4C1130, //
  ];

  static const List<int> standardColors = <int>[
    0xFF000000, 0xFFFFFFFF, 0xFF4285F4, 0xFFEA4335, 0xFFFBBC04, 0xFF34A853, 0xFFFF6D01, 0xFF46BDC6 //
  ];

  static BorderSide defaultBorderSide = const BorderSide(color: Color(0x1F040404));
}