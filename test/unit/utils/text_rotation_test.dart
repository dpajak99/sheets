import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/text_rotation.dart';

void main() {
  group('Tests of TextRotation', () {
    group('TextRotation predefined constants', () {
      test('Should return the correct angle for TextRotation.none', () {
        expect(TextRotation.none.angle, 0);
      });

      test('Should return the correct angle for TextRotation.angleDown', () {
        expect(TextRotation.angleDown.angle, 45);
      });

      test('Should return the correct angle for TextRotation.angleUp', () {
        expect(TextRotation.angleUp.angle, -45);
      });

      test('Should return the correct angle for TextRotation.down', () {
        expect(TextRotation.down.angle, 90);
      });

      test('Should return the correct angle for TextRotation.up', () {
        expect(TextRotation.up.angle, -90);
      });

      test('Should return 0 for TextRotation.vertical', () {
        expect(TextRotation.vertical.angle, 0);
      });
    });

    group('TextRotation custom angle', () {
      test('Should correctly create a custom angle within bounds (-90 to 90)', () {
        TextRotation customRotation = TextRotation.custom(30);
        expect(customRotation.angle, 30);
      });

      test('Should correctly normalize angles using modulo 90', () {
        TextRotation customRotation = TextRotation.custom(450);
        expect(customRotation.angle, 0); // 450 % 90 = 0
      });
    });
  });
}
