import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_property.dart';
import 'package:sheets/core/clipboard/encoders/html/css/css_style.dart';
import 'package:sheets/core/clipboard/encoders/html/elements/html_element.dart';

class MockCssStyle extends CssStyle {
  MockCssStyle(this.styleMap);

  final Map<String, String> styleMap;

  @override
  Map<String, String> get propertiesMap => styleMap;

  @override
  List<CssProperty> get properties => <CssProperty<dynamic, CssValue<dynamic>>>[];
}

class TestHtmlElement extends HtmlElement {
  TestHtmlElement({required super.tagName, required this.mockContent});

  final String mockContent;

  @override
  String get content => mockContent;

  @override
  Map<String, String> get attributes => <String, String>{'class': 'test-class'};

  @override
  List<Object?> get props => <Object?>[tagName, content, attributes];
}

class TestStyledHtmlElement extends StyledHtmlElement {
  TestStyledHtmlElement({
    required super.tagName,
    required this.mockContent,
    this.mockStyles,
  });

  final String mockContent;
  final CssStyle? mockStyles;

  @override
  String get content => mockContent;

  @override
  CssStyle? get styles => mockStyles;

  @override
  Map<String, String> get attributes => <String, String>{'id': 'test-id'};

  @override
  List<Object?> get props => <Object?>[tagName, content, styles, attributes];
}

void main() {
  group('HtmlElement', () {
    test('renders HTML correctly without attributes', () {
      HtmlElement element = TestHtmlElement(tagName: 'div', mockContent: 'Hello, World!');

      String result = element.toHtml();

      expect(result, '<div class="test-class">Hello, World!</div>');
    });

    test('renders HTML correctly with attributes', () {
      HtmlElement element = TestHtmlElement(tagName: 'span', mockContent: 'Test content');

      String result = element.toHtml();

      expect(result, '<span class="test-class">Test content</span>');
    });
  });

  group('StyledHtmlElement', () {
    test('renders HTML correctly with styles', () {
      CssStyle styles = MockCssStyle(<String, String>{'color': 'red', 'font-size': '16px'});
      StyledHtmlElement element = TestStyledHtmlElement(
        tagName: 'p',
        mockContent: 'Styled content',
        mockStyles: styles,
      );

      String result = element.toHtml();

      expect(
        result,
        '<p style="color:red;font-size:16px" id="test-id">Styled content</p>',
      );
    });

    test('renders HTML correctly without styles', () {
      StyledHtmlElement element = TestStyledHtmlElement(
        tagName: 'p',
        mockContent: 'No styles content',
      );

      String result = element.toHtml();

      expect(result, '<p id="test-id">No styles content</p>');
    });

    test('renders HTML correctly with styles and attributes', () {
      CssStyle styles = MockCssStyle(<String, String>{'margin': '10px', 'padding': '5px'});
      StyledHtmlElement element = TestStyledHtmlElement(
        tagName: 'div',
        mockContent: 'Complex content',
        mockStyles: styles,
      );

      String result = element.toHtml();

      expect(
        result,
        '<div style="margin:10px;padding:5px" id="test-id">Complex content</div>',
      );
    });
  });
}
