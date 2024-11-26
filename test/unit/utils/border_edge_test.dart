import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/border_edge.dart';

void main() {
  group('Tests of BorderEdge.opposite', () {
    test('Should return BorderEdge.bottom for BorderEdge.top', () {
      expect(BorderEdge.top.opposite, BorderEdge.bottom);
    });

    test('Should return BorderEdge.top for BorderEdge.bottom', () {
      expect(BorderEdge.bottom.opposite, BorderEdge.top);
    });

    test('Should return BorderEdge.left for BorderEdge.right', () {
      expect(BorderEdge.right.opposite, BorderEdge.left);
    });

    test('Should return BorderEdge.right for BorderEdge.left', () {
      expect(BorderEdge.left.opposite, BorderEdge.right);
    });
  });
}
