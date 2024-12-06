abstract class HtmlElement {
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

  Map<String, String> get styles => <String, String>{};

  @override
  String toHtml() {
    String styleStr = styles.isNotEmpty ? ' style="${_styleToString()}"' : '';
    String attrStr = attributes.isEmpty ? '' : ' ${_attributesToStringWithoutTag()}';
    return '<$tagName$styleStr$attrStr>$content</$tagName>';
  }

  String _styleToString() => styles.entries.map((MapEntry<String, String> e) => '${e.key}:${e.value}').join(';');

  String _attributesToStringWithoutTag() {
    return attributes.entries.map((MapEntry<String, String> e) => '${e.key}="${e.value}"').join(' ');
  }
}
