import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_color.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_double.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssBorder extends CssProperty<Border, CssBorderValue> {
  CssBorder._(super.value);

  static const List<String> supportedProperties = <String>[
    'border',
    'border-top',
    'border-right',
    'border-bottom',
    'border-left'
  ];

  static CssBorder? fromDart(Border? border) {
    if (border == null) {
      return null;
    }
    CssBorderValue value = CssBorderValue.fromDart(border);
    return CssBorder._(value);
  }

  static CssBorder? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }

    CssBorderSideValue? border = CssBorderSideValue.fromCss(map['border']);
    if (border != null) {
      CssBorderValue value = CssBorderValue.all(border);
      return CssBorder._(value);
    }
    CssBorderSideValue? top = CssBorderSideValue.fromCss(map['border-top']);
    CssBorderSideValue? right = CssBorderSideValue.fromCss(map['border-right']);
    CssBorderSideValue? bottom = CssBorderSideValue.fromCss(map['border-bottom']);
    CssBorderSideValue? left = CssBorderSideValue.fromCss(map['border-left']);

    CssBorderValue value = CssBorderValue(top: top, right: right, bottom: bottom, left: left);
    return CssBorder._(value);
  }

  @override
  Map<String, String> toCssMap() {
    if (value.hasNoBorders) {
      return <String, String>{};
    }

    if (value.isUniform) {
      return <String, String>{
        'border': value.top!.toCss(),
      };
    }

    return <String, String>{
      if (value.top != null) 'border-top': value.top!.toCss(),
      if (value.right != null) 'border-right': value.right!.toCss(),
      if (value.bottom != null) 'border-bottom': value.bottom!.toCss(),
      if (value.left != null) 'border-left': value.left!.toCss(),
    };
  }
}

class CssBorderValue extends CssValue<Border> {
  CssBorderValue({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  CssBorderValue.all(CssBorderSideValue value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  static CssBorderValue fromDart(Border value) {
    return CssBorderValue(
      top: CssBorderSideValue.fromDart(value.top),
      right: CssBorderSideValue.fromDart(value.right),
      bottom: CssBorderSideValue.fromDart(value.bottom),
      left: CssBorderSideValue.fromDart(value.left),
    );
  }

  final CssBorderSideValue? top;
  final CssBorderSideValue? right;
  final CssBorderSideValue? bottom;
  final CssBorderSideValue? left;

  bool get hasNoBorders => top == null && right == null && bottom == null && left == null;

  bool get hasAllBorders => top != null && right != null && bottom != null && left != null;

  bool get isUniform => top == right && right == bottom && bottom == left;

  @override
  Border toDart() {
    if (hasNoBorders) {
      return const Border.fromBorderSide(BorderSide.none);
    }

    return Border(
      top: top?.toDart() ?? BorderSide.none,
      right: right?.toDart() ?? BorderSide.none,
      bottom: bottom?.toDart() ?? BorderSide.none,
      left: left?.toDart() ?? BorderSide.none,
    );
  }

  @override
  List<Object?> get props => <Object?>[top, right, bottom, left];
}

class CssBorderSideValue extends CssValue<BorderSide> {
  CssBorderSideValue._(this._value);

  static CssBorderSideValue? fromCss(String? value) {
    if (value == null) {
      return null;
    }
    List<String> parts = value.split(' ').map((String p) => p.trim()).where((String p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      throw Exception('Unknown value: $value');
    }

    CssDoubleValue? width;
    CssColorValue? color;

    for (String part in parts) {
      if (CssColorValue.canParseCss(part)) {
        color = CssColorValue.fromCss(part);
      }
      if (CssDoubleValue.canParseCss(part)) {
        width = CssDoubleValue.fromCss(part);
      }
    }

    if (width == null && color == null) {
      return CssBorderSideValue._(BorderSide.none);
    }

    return CssBorderSideValue._(BorderSide(width: width!.toDart(), color: color!.toDart()));
  }

  static CssBorderSideValue fromDart(BorderSide value) {
    return CssBorderSideValue._(value);
  }

  final BorderSide _value;

  @override
  BorderSide toDart() => _value;

  String toCss() {
    if (_value == BorderSide.none) {
      return 'none';
    }
    return '${_value.width}px solid ${CssColorValue.fromDart(_value.color).toCss()}';
  }

  bool get isDefault => _value == BorderSide.none;
}
