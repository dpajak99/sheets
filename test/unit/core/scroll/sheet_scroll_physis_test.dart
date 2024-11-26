// import 'package:flutter_test/flutter_test.dart';
// import 'package:sheets/core/scroll/sheet_axis_direction.dart';
// import 'package:sheets/core/scroll/sheet_scroll_controller.dart';
// import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
// import 'package:sheets/core/scroll/sheet_scroll_physics.dart';
//
// void main() {
//   group('Tests of SheetScrollPhysics', () {
//     group('Tests of SmoothScrollPhysics.parseScrolledOffset()', () {
//       test('Should [limit offset within bounds] when [delta is applied]', () {
//         // Arrange
//         SheetScrollController scrollController = SheetScrollController();
//         SmoothScrollPhysics physics = SmoothScrollPhysics();
//         physics.applyTo(scrollController);
//
//         scrollController.metrics.update(
//           horizontal: SheetScrollMetrics(
//             axisDirection: SheetAxisDirection.horizontal,
//             contentSize: 1000,
//             viewportDimension: 600,
//           ),
//           vertical: SheetScrollMetrics(
//             axisDirection: SheetAxisDirection.vertical,
//             contentSize: 800,
//             viewportDimension: 600,
//           ),
//         );
//
//         Offset currentOffset = const Offset(500, 300);
//         Offset delta = const Offset(600, 600);
//
//         // Act
//         Offset newOffset = physics.parseScrolledOffset(currentOffset, delta);
//
//         // Assert
//         expect(newOffset.dx, 400.0); // Max horizontal extent: 400.0
//         expect(newOffset.dy, 200.0); // Max vertical extent: 200.0
//       });
//
//       test('Should [allow negative offsets down to zero]', () {
//         // Arrange
//         SheetScrollController scrollController = SheetScrollController();
//         SmoothScrollPhysics physics = SmoothScrollPhysics();
//         physics.applyTo(scrollController);
//
//         scrollController.metrics.update(
//           horizontal: SheetScrollMetrics(
//             axisDirection: SheetAxisDirection.horizontal,
//             contentSize: 1000,
//             viewportDimension: 600,
//           ),
//           vertical: SheetScrollMetrics(
//             axisDirection: SheetAxisDirection.vertical,
//             contentSize: 800,
//             viewportDimension: 600,
//           ),
//         );
//
//         Offset currentOffset = const Offset(100, 100);
//         Offset delta = const Offset(-200, -200);
//
//         // Act
//         Offset newOffset = physics.parseScrolledOffset(currentOffset, delta);
//
//         // Assert
//         expect(newOffset.dx, 0.0);
//         expect(newOffset.dy, 0.0);
//       });
//     });
//   });
// }
