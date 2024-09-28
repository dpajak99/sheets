// import 'package:flutter/material.dart';
// import 'package:sheets/controller/program_config.dart';
// import 'package:sheets/controller/sheet_cursor_controller.dart';
// import 'package:sheets/multi_listenable_builder.dart';
// import 'package:sheets/painters/headers_painter.dart';
// import 'package:sheets/painters/selection_painter.dart';
// import 'package:sheets/controller/sheet_controller.dart';
// import 'package:sheets/painters/sheet_painter.dart';
// import 'package:sheets/sheet_constants.dart';
//
// class FillHandleOffset extends StatelessWidget {
//   final SheetCursorController cursorController;
//
//   const FillHandleOffset({
//     required this.cursorController,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanStart: (DragStartDetails details) {
//         cursorController.isFilling = true;
//         cursorController.dragStart(details, subtract: const Offset(4, 4));
//         cursorController.setCursor(SystemMouseCursors.basic, SystemMouseCursors.precise);
//       },
//       onPanUpdate: (DragUpdateDetails details) {
//         cursorController.dragUpdate(details, subtract: const Offset(4, 4));
//       },
//       onPanEnd: (DragEndDetails details) {
//         cursorController.isFilling = false;
//         cursorController.dragEnd(details);
//         cursorController.setCursor(SystemMouseCursors.precise, SystemMouseCursors.basic);
//       },
//       child: MouseRegion(
//         onEnter: (_) {
//           cursorController.setCursor(SystemMouseCursors.basic, SystemMouseCursors.precise);
//         },
//         onExit: (_) {
//           cursorController.setCursor(SystemMouseCursors.precise, SystemMouseCursors.basic);
//         },
//         child: const SizedBox(height: 8, width: 8),
//       ),
//     );
//   }
// }
//
// class SheetTextField extends StatelessWidget {
//   final CellConfig cellConfig;
//
//   const SheetTextField({super.key, required this.cellConfig});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xffa8c7fa), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: const Color(0xff3572e3), width: 2),
//         ),
//         child: IntrinsicWidth(
//           child: TextField(
//             autofocus: true,
//             controller: TextEditingController(text: cellConfig.value),
//             style: defaultTextStyle,
//             decoration: const InputDecoration(
//               isDense: true,
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
