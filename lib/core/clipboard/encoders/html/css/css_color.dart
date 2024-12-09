import 'package:flutter/material.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

class CssColor extends CssProperty<Color, CssColorValue> {
  CssColor._(super.value);

  static const List<String> supportedProperties = <String>['color'];

  static CssColor? fromDart(Color? value) {
    if (value == null) {
      return null;
    }
    CssColorValue color = CssColorValue.fromDart(value);
    return CssColor._(color);
  }

  static CssColor? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }
    CssColorValue? color = CssColorValue.fromCss(map['color']);
    return CssColor._(color!);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'color': value.toCss()};
  }
}

class CssBackgroundColor extends CssProperty<Color, CssColorValue> {
  CssBackgroundColor._(super.value);

  static const List<String> supportedProperties = <String>['background-color'];

  static CssBackgroundColor? fromDart(Color? dart) {
    if (dart == null) {
      return null;
    }
    CssColorValue color = CssColorValue.fromDart(dart);
    return CssBackgroundColor._(color);
  }

  static CssBackgroundColor? fromCssMap(Map<String, String> map) {
    if (!map.keys.any((String key) => supportedProperties.contains(key))) {
      return null;
    }

    CssColorValue? color = CssColorValue.fromCss(map['background-color']);
    return CssBackgroundColor._(color!);
  }

  @override
  Map<String, String> toCssMap() {
    return <String, String>{'background-color': value.toCss()};
  }
}

class CssColorValue extends CssValue<Color> {
  CssColorValue._(this._value);

  factory CssColorValue._fromHex(String value) {
    String hex = value.substring(1);
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return CssColorValue._(Color(int.parse(hex, radix: 16)));
  }

  factory CssColorValue._fromRgb(String value) {
    List<String> parts = value.substring(4, value.length - 1).split(',').map((String p) => p.trim()).toList();
    return CssColorValue._(Color.fromARGB(255, int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])));
  }

  factory CssColorValue._fromRgba(String value) {
    List<String> parts = value.substring(5, value.length - 1).split(',').map((String p) => p.trim()).toList();
    return CssColorValue._(Color.fromRGBO(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
      double.parse(parts[3]),
    ));
  }

  static CssColorValue? fromCss(String? value) {
    if (value == null) {
      return null;
    }

    if (value.startsWith('#')) {
      return CssColorValue._fromHex(value);
    } else if (value.startsWith('rgba')) {
      return CssColorValue._fromRgba(value);
    } else if (value.startsWith('rgb')) {
      return CssColorValue._fromRgb(value);
    } else if (CssColors.values.any((CssColors c) => c.name == value)) {
      return CssColorValue._(CssColors.values.firstWhere((CssColors c) => c.name == value).color);
    } else {
      throw Exception('Unknown color: $value');
    }
  }

  static CssColorValue fromDart(Color value) {
    return CssColorValue._(value);
  }

  static bool canParseCss(String value) {
    return value.startsWith('#') ||
        value.startsWith('rgb') ||
        value.startsWith('rgba') ||
        CssColors.values.any((CssColors c) => c.name == value);
  }

  final Color _value;

  @override
  Color toDart() => _value;

  String toCss() {
    int r = _value.red;
    int g = _value.green;
    int b = _value.blue;

    if (_value.alpha == 255) {
      return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
    } else {
      return 'rgba($r, $g, $b, ${(_value.alpha / 255).toStringAsFixed(2)})';
    }
  }
}

enum CssColors {
  transparent('transparent', Colors.transparent),
  black('black', Color(0xFF000000)),
  silver('silver', Color(0xFFC0C0C0)),
  gray('gray', Color(0xFF808080)),
  white('white', Color(0xFFFFFFFF)),
  maroon('maroon', Color(0xFF800000)),
  red('red', Color(0xFFFF0000)),
  purple('purple', Color(0xFF800080)),
  fuchsia('fuchsia', Color(0xFFFF00FF)),
  green('green', Color(0xFF008000)),
  lime('lime', Color(0xFF00FF00)),
  olive('olive', Color(0xFF808000)),
  yellow('yellow', Color(0xFFFFFF00)),
  navy('navy', Color(0xFF000080)),
  blue('blue', Color(0xFF0000FF)),
  teal('teal', Color(0xFF008080)),
  aqua('aqua', Color(0xFF00FFFF)),
  aliceblue('aliceblue', Color(0xFFF0F8FF)),
  antiquewhite('antiquewhite', Color(0xFFFAEBD7)),
  aquamarine('aquamarine', Color(0xFF7FFFD4)),
  azure('azure', Color(0xFFF0FFFF)),
  beige('beige', Color(0xFFF5F5DC)),
  bisque('bisque', Color(0xFFFFE4C4)),
  blanchedalmond('blanchedalmond', Color(0xFFFFEBCD)),
  blueviolet('blueviolet', Color(0xFF8A2BE2)),
  brown('brown', Color(0xFFA52A2A)),
  burlywood('burlywood', Color(0xFFDEB887)),
  cadetblue('cadetblue', Color(0xFF5F9EA0)),
  chartreuse('chartreuse', Color(0xFF7FFF00)),
  chocolate('chocolate', Color(0xFFD2691E)),
  coral('coral', Color(0xFFFF7F50)),
  cornflowerblue('cornflowerblue', Color(0xFF6495ED)),
  cornsilk('cornsilk', Color(0xFFFFF8DC)),
  crimson('crimson', Color(0xFFDC143C)),
  cyan('cyan', Color(0xFF00FFFF)),
  darkblue('darkblue', Color(0xFF00008B)),
  darkcyan('darkcyan', Color(0xFF008B8B)),
  darkgoldenrod('darkgoldenrod', Color(0xFFB8860B)),
  darkgray('darkgray', Color(0xFFA9A9A9)),
  darkgreen('darkgreen', Color(0xFF006400)),
  darkkhaki('darkkhaki', Color(0xFFBDB76B)),
  darkmagenta('darkmagenta', Color(0xFF8B008B)),
  darkolivegreen('darkolivegreen', Color(0xFF556B2F)),
  darkorange('darkorange', Color(0xFFFF8C00)),
  darkorchid('darkorchid', Color(0xFF9932CC)),
  darkred('darkred', Color(0xFF8B0000)),
  darksalmon('darksalmon', Color(0xFFE9967A)),
  darkseagreen('darkseagreen', Color(0xFF8FBC8F)),
  darkslateblue('darkslateblue', Color(0xFF483D8B)),
  darkslategray('darkslategray', Color(0xFF2F4F4F)),
  darkturquoise('darkturquoise', Color(0xFF00CED1)),
  darkviolet('darkviolet', Color(0xFF9400D3)),
  deeppink('deeppink', Color(0xFFFF1493)),
  deepskyblue('deepskyblue', Color(0xFF00BFFF)),
  dimgray('dimgray', Color(0xFF696969)),
  dodgerblue('dodgerblue', Color(0xFF1E90FF)),
  firebrick('firebrick', Color(0xFFB22222)),
  floralwhite('floralwhite', Color(0xFFFFFAF0)),
  forestgreen('forestgreen', Color(0xFF228B22)),
  gainsboro('gainsboro', Color(0xFFDCDCDC)),
  ghostwhite('ghostwhite', Color(0xFFF8F8FF)),
  gold('gold', Color(0xFFFFD700)),
  goldenrod('goldenrod', Color(0xFFDAA520)),
  greenyellow('greenyellow', Color(0xFFADFF2F)),
  grey('grey', Color(0xFF808080)),
  honeydew('honeydew', Color(0xFFF0FFF0)),
  hotpink('hotpink', Color(0xFFFF69B4)),
  indianred('indianred', Color(0xFFCD5C5C)),
  indigo('indigo', Color(0xFF4B0082)),
  ivory('ivory', Color(0xFFFFFFF0)),
  khaki('khaki', Color(0xFFF0E68C)),
  lavender('lavender', Color(0xFFE6E6FA)),
  lavenderblush('lavenderblush', Color(0xFFFFF0F5)),
  lawngreen('lawngreen', Color(0xFF7CFC00)),
  lemonchiffon('lemonchiffon', Color(0xFFFFFACD)),
  lightblue('lightblue', Color(0xFFADD8E6)),
  lightcoral('lightcoral', Color(0xFFF08080)),
  lightcyan('lightcyan', Color(0xFFE0FFFF)),
  lightgoldenrodyellow('lightgoldenrodyellow', Color(0xFFFAFAD2)),
  lightgray('lightgray', Color(0xFFD3D3D3)),
  lightgreen('lightgreen', Color(0xFF90EE90)),
  lightpink('lightpink', Color(0xFFFFB6C1)),
  lightsalmon('lightsalmon', Color(0xFFFFA07A)),
  lightseagreen('lightseagreen', Color(0xFF20B2AA)),
  lightskyblue('lightskyblue', Color(0xFF87CEFA)),
  lightslategray('lightslategray', Color(0xFF778899)),
  lightsteelblue('lightsteelblue', Color(0xFFB0C4DE)),
  lightyellow('lightyellow', Color(0xFFFFFFE0)),
  limegreen('limegreen', Color(0xFF32CD32)),
  linen('linen', Color(0xFFFAF0E6)),
  magenta('magenta', Color(0xFFFF00FF)),
  mediumaquamarine('mediumaquamarine', Color(0xFF66CDAA)),
  mediumblue('mediumblue', Color(0xFF0000CD)),
  mediumorchid('mediumorchid', Color(0xFFBA55D3)),
  mediumpurple('mediumpurple', Color(0xFF9370DB)),
  mediumseagreen('mediumseagreen', Color(0xFF3CB371)),
  mediumslateblue('mediumslateblue', Color(0xFF7B68EE)),
  mediumspringgreen('mediumspringgreen', Color(0xFF00FA9A)),
  mediumturquoise('mediumturquoise', Color(0xFF48D1CC)),
  mediumvioletred('mediumvioletred', Color(0xFFC71585)),
  midnightblue('midnightblue', Color(0xFF191970)),
  mintcream('mintcream', Color(0xFFF5FFFA)),
  mistyrose('mistyrose', Color(0xFFFFE4E1)),
  moccasin('moccasin', Color(0xFFFFE4B5)),
  navajowhite('navajowhite', Color(0xFFFFDEAD)),
  oldlace('oldlace', Color(0xFFFDF5E6)),
  olivedrab('olivedrab', Color(0xFF6B8E23)),
  orange('orange', Color(0xFFFFA500)),
  orangered('orangered', Color(0xFFFF4500)),
  orchid('orchid', Color(0xFFDA70D6)),
  palegoldenrod('palegoldenrod', Color(0xFFEEE8AA)),
  palegreen('palegreen', Color(0xFF98FB98)),
  paleturquoise('paleturquoise', Color(0xFFAFEEEE)),
  palevioletred('palevioletred', Color(0xFFDB7093)),
  papayawhip('papayawhip', Color(0xFFFFEFD5)),
  peachpuff('peachpuff', Color(0xFFFFDAB9)),
  peru('peru', Color(0xFFCD853F)),
  pink('pink', Color(0xFFFFC0CB)),
  plum('plum', Color(0xFFDDA0DD)),
  powderblue('powderblue', Color(0xFFB0E0E6)),
  rebeccapurple('rebeccapurple', Color(0xFF663399)),
  rosybrown('rosybrown', Color(0xFFBC8F8F)),
  royalblue('royalblue', Color(0xFF4169E1)),
  saddlebrown('saddlebrown', Color(0xFF8B4513)),
  salmon('salmon', Color(0xFFFA8072)),
  sandybrown('sandybrown', Color(0xFFF4A460)),
  seagreen('seagreen', Color(0xFF2E8B57)),
  seashell('seashell', Color(0xFFFFF5EE)),
  sienna('sienna', Color(0xFFA0522D)),
  skyblue('skyblue', Color(0xFF87CEEB)),
  slateblue('slateblue', Color(0xFF6A5ACD)),
  slategray('slategray', Color(0xFF708090)),
  snow('snow', Color(0xFFFFFAFA)),
  springgreen('springgreen', Color(0xFF00FF7F)),
  steelblue('steelblue', Color(0xFF4682B4)),
  tan('tan', Color(0xFFD2B48C)),
  thistle('thistle', Color(0xFFD8BFD8)),
  tomato('tomato', Color(0xFFFF6347)),
  turquoise('turquoise', Color(0xFF40E0D0)),
  violet('violet', Color(0xFFEE82EE)),
  wheat('wheat', Color(0xFFF5DEB3)),
  whitesmoke('whitesmoke', Color(0xFFF5F5F5)),
  yellowgreen('yellowgreen', Color(0xFF9ACD32));

  const CssColors(this.name, this.color);

  final String name;
  final Color color;

  @override
  String toString() {
    return '$name: ${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
