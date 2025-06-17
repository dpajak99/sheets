import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/sheet_style.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/utils/extensions/text_span_extensions.dart';
import 'package:sheets/utils/text_rotation.dart';

class CellTextPainter {
  const CellTextPainter(this.padding);

  final EdgeInsets padding;

  void paint(Canvas canvas, ViewportCell cell) {
    final SheetRichText richText = cell.properties.visibleRichText;
    if (richText.isEmpty) return;

    final CellStyle style = cell.properties.style;
    final TextPainter painter = _createPainter(richText, cell.properties);
    final Offset offset = _calculateOffset(painter, cell, style);

    _drawText(canvas, painter, cell.rect.topLeft + offset, style.rotation);
  }

  TextPainter _createPainter(SheetRichText text, CellProperties props) {
    TextSpan span = text.toTextSpan();
    if (props.style.rotation == TextRotation.vertical) {
      span = span.applyDivider('\n');
    }

    return TextPainter(
      text: span,
      textAlign: props.visibleTextAlign,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  Offset _calculateOffset(TextPainter painter, ViewportCell cell, CellStyle style) {
    final double width = cell.rect.width - padding.horizontal;
    final double height = cell.rect.height - padding.vertical;

    final Size rotated = _rotatedSize(painter, style.rotation);

    double dx = padding.left;
    switch (cell.properties.visibleTextAlign) {
      case TextAlign.center:
        dx += (width - rotated.width) / 2;
        break;
      case TextAlign.right:
      case TextAlign.end:
        dx += width - rotated.width;
        break;
      case TextAlign.left:
      case TextAlign.start:
      case TextAlign.justify:
        break;
    }

    double dy = padding.top;
    final TextAlignVertical vertical = style.verticalAlign;
    if (vertical == TextAlignVertical.center) {
      dy += (height - rotated.height) / 2;
    } else if (vertical == TextAlignVertical.bottom) {
      dy += height - rotated.height;
    }

    return Offset(dx, dy);
  }

  Size _rotatedSize(TextPainter painter, TextRotation rotation) {
    final double angle = rotation.angle * pi / 180;
    final double c = cos(angle).abs();
    final double s = sin(angle).abs();
    return Size(
      painter.width * c + painter.height * s,
      painter.width * s + painter.height * c,
    );
  }

  void _drawText(
    Canvas canvas,
    TextPainter painter,
    Offset position,
    TextRotation rotation,
  ) {
    canvas.save();
    if (rotation != TextRotation.none && rotation != TextRotation.vertical) {
      final double angle = rotation.angle * pi / 180;
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle);
      painter.paint(canvas, Offset.zero);
    } else {
      painter.paint(canvas, position);
    }
    canvas.restore();
  }
}
