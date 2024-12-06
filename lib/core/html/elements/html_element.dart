import 'package:equatable/equatable.dart';

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

  CssStyle get styles => CssStyle.empty();

  @override
  String toHtml() {
    String styleStr = styles.isNotEmpty ? ' style="${styles.oneline}"' : '';
    String attrStr = attributes.isEmpty ? '' : ' ${_attributesToStringWithoutTag()}';
    return '<$tagName$styleStr$attrStr>$content</$tagName>';
  }

  String _attributesToStringWithoutTag() {
    return attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
  }
}

class CssStyle with EquatableMixin {
  CssStyle.css(this.styles) {
    _cleanup();
  }

  CssStyle.empty() : styles = <String, String>{};

  final Map<String, String> styles;

  void add(String key, String value) {
    if (supportedStyles.contains(key) && value.isNotEmpty) {
      styles[key] = value;
    }
  }

  String get oneline {
    return styles.entries.map((MapEntry<String, Object> e) => '${e.key}:${e.value}').join(';');
  }

  bool get isEmpty => styles.isEmpty;

  bool get isNotEmpty => styles.isNotEmpty;

  void addOther(CssStyle other) {
    other.styles.forEach(add);
  }

  List<String> get supportedStyles => styles.keys.toList();

  void _cleanup() {
    styles.removeWhere((String key, String value) => value.isEmpty);
    styles.removeWhere((String key, String value) => !supportedStyles.contains(key));
  }

  @override
  List<Object?> get props => <Object>[styles];
}
