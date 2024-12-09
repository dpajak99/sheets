import 'package:equatable/equatable.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';

abstract class CssStyle with EquatableMixin {
  static Map<String, String> decodeProperties(String? style) {
    Map<String, String> attributes = <String, String>{};
    if (style == null) {
      return attributes;
    }
    List<String> parts = style.split(';');
    for (String part in parts) {
      List<String> keyValue = part.split(':');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        attributes[key] = value;
      }
    }
    return attributes;
  }

  bool get isEmpty => properties.isEmpty;

  List<CssProperty> get properties;

  Map<String, String> get propertiesMap {
    Map<String, String> map = <String, String>{};
    for (CssProperty? property in properties) {
      if (property == null) {
        continue;
      }
      map.addAll(property.toCssMap());
    }
    return map;
  }

  @override
  List<Object?> get props => <Object?>[properties];
}

class CombinedCssStyle extends CssStyle {
  CombinedCssStyle({required this.styles});

  final List<CssStyle> styles;

  @override
  List<CssProperty> get properties {
    List<CssProperty> properties = <CssProperty>[];
    for (CssStyle style in styles) {
      properties.addAll(style.properties);
    }
    return properties;
  }
}
