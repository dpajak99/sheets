import 'package:flutter/material.dart';

double borderWidth = 1;

double scrollbarWidth = 14;

int columnHeadersCount = 1;
int rowHeadersCount = 1;

double columnHeadersHeight = 24;
double rowHeadersWidth = 46;

double defaultColumnWidth = 100;
double defaultRowHeight = 21;

double resizerGapSize = 5;
double resizerWeight = 3;
double resizerLength = 16;

const TextStyle defaultTextStyle = TextStyle(
  fontFamily: 'Arial',
  fontSize: 12,
  color: Colors.black,
  letterSpacing: 0,
);

TextStyle defaultHeaderTextStyle = const TextStyle(
  color: Color(0xff444746),
  fontSize: 11,
  fontFamily: 'Arial',
);

TextStyle defaultHeaderTextStyleSelected = const TextStyle(
  color: Color(0xff0a1e47),
  fontSize: 11,
  fontWeight: FontWeight.bold,
  fontFamily: 'Arial',
);

TextStyle defaultHeaderTextStyleSelectedAll = const TextStyle(
  color: Color(0xffffffff),
  fontSize: 11,
  fontWeight: FontWeight.bold,
  fontFamily: 'Arial',
);
