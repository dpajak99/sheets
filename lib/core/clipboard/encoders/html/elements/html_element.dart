import 'package:equatable/equatable.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';

abstract class HtmlElement with EquatableMixin {
  HtmlElement({required this.tagName});

  final String tagName;

  String get content;

  Map<String, String> get attributes => <String, String>{};

  String toHtml() {
    return '<$tagName${_attributesToString()}>$content</$tagName>';
  }

  String _attributesToString() {
    if (attributes.isEmpty) {
      return '';
    }
    String attrString = attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
    return ' $attrString';
  }
}

abstract class StyledHtmlElement extends HtmlElement {
  StyledHtmlElement({required super.tagName});

  CssStyle? get styles => null;

  @override
  String toHtml() {
    Map<String, String> styleMap = styles?.propertiesMap ?? <String, String>{};
    String styleStr = styleMap.isNotEmpty ? ' style="${_styleMapToString(styleMap)}"' : '';
    String attrStr = attributes.isEmpty ? '' : ' ${_attributesToStringWithoutTag()}';
    return '<$tagName$styleStr$attrStr>$content</$tagName>';
  }

  String _attributesToStringWithoutTag() {
    return attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
  }

  String _styleMapToString(Map<String, String> styleMap) {
    return styleMap.entries.map((MapEntry<String, String> e) => '${e.key}:${e.value}').join(';');
  }
}
