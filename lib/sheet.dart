import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/layers/sheet_cells_layer.dart';
import 'package:sheets/layers/sheet_fill_handle_layer.dart';
import 'package:sheets/layers/sheet_headers_layer.dart';
import 'package:sheets/layers/sheet_headers_resizer_layer.dart';
import 'package:sheets/layers/sheet_selection_layer.dart';
import 'package:sheets/config/sheet_constants.dart';
import 'package:sheets/sheet_gesture_detector.dart';
import 'package:sheets/sheet_scrollable.dart';
import 'package:sheets/widgets/sheet_cell_info_bar.dart';
import 'package:sheets/widgets/sheet_toolbar.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key});

  @override
  State<StatefulWidget> createState() => SheetPageState();
}

class SheetPageState extends State<SheetPage> {
  final SheetController sheetController = SheetController();

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKeyboardKeyPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SheetToolbar(),
        SheetCellInfoBar(sheetController: sheetController),
        Expanded(
          child: FlexibleSheet(sheetController: sheetController),
        ),
      ],
    ));
  }

  bool _onKeyboardKeyPressed(KeyEvent event) {
    if (event is KeyDownEvent) {
      sheetController.keyboard.addKey(event.logicalKey);
    } else if (event is KeyUpEvent) {
      sheetController.keyboard.removeKey(event.logicalKey);
    }
    return false;
  }
}

class FlexibleSheet extends StatelessWidget {
  final SheetController sheetController;

  const FlexibleSheet({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Sheet(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          sheetController: sheetController,
        );
      },
    );
  }
}

class Sheet extends StatefulWidget {
  final double width;
  final double height;
  final SheetController sheetController;

  const Sheet({
    required this.width,
    required this.height,
    required this.sheetController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SheetState();

  static SheetState of(BuildContext context) {
    return context.findAncestorStateOfType<SheetState>()!;
  }
}

class SheetState extends State<Sheet> {
  SheetController get sheetController => widget.sheetController;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKeyboardKeyPressed);
    sheetController.scrollController.viewportSize = Size(widget.width, widget.height);
  }

  @override
  void didUpdateWidget(covariant Sheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      sheetController.scrollController.viewportSize = Size(widget.width, widget.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xfff8faf8),
        ),
        child: SheetScrollable(
          scrollController: sheetController.scrollController,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SheetGrid(sheetController: sheetController),
              ),
              Positioned.fill(
                child: SheetGestureDetector(
                  cursorListener: sheetController.mouse.cursor,
                  onMouseOffsetChanged: sheetController.onMouseOffsetChanged,
                  onTap: sheetController.mouse.tap,
                  onDragStart: sheetController.mouse.dragStart,
                  onDragUpdate: sheetController.mouse.dragUpdate,
                  onDragEnd: sheetController.mouse.dragEnd,
                  onScroll: sheetController.mouse.scroll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _onKeyboardKeyPressed(KeyEvent event) {
    if (event is KeyDownEvent) {
      sheetController.keyboard.addKey(event.logicalKey);
    } else if (event is KeyUpEvent) {
      sheetController.keyboard.removeKey(event.logicalKey);
    }
    return false;
  }

  void disableMouseActions() {
    sheetController.mouse.disable();
  }

  void enableMouseActions() {
    sheetController.mouse.enable();
  }

  bool areMouseActionsEnabled() {
    return sheetController.mouse.enabled;
  }

  bool isNativeDragging() {
    return sheetController.mouse.nativeDragging;
  }

  void setCustomTapHovered(bool value) {
    sheetController.mouse.customTapHovered = value;
  }

  void setCursor(SystemMouseCursor cursor) {
    sheetController.mouse.cursor.value = cursor;
  }

  void resetCursor() {
    sheetController.mouse.cursor.value = SystemMouseCursors.basic;
  }
}

class SheetGrid extends StatelessWidget {
  final SheetController sheetController;

  const SheetGrid({
    required this.sheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          bottom: 0,
          left: 50,
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Add more'),
            ],
          ),
        ),
        Positioned.fill(child: SheetCellsLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetHeadersLayer(sheetController: sheetController)),
        Positioned.fill(child: HeadersResizerLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetSelectionLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetFillHandleLayer(sheetController: sheetController)),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: rowHeadersWidth,
            height: columnHeadersHeight,
            decoration: const BoxDecoration(
              color: Color(0xfff8f9fa),
              border: Border(
                right: BorderSide(color: Color(0xffc7c7c7), width: 4),
                bottom: BorderSide(color: Color(0xffc7c7c7), width: 4),
              ),
            ),
          ),
        ),
        // Positioned.fill(
        //   child: ValueListenableBuilder<CellConfig?>(
        //     valueListenable: sheetController.editNotifier,
        //     builder: (BuildContext context, CellConfig? cellConfig, _) {
        //       return Stack(
        //         children: [
        //           if (cellConfig != null)
        //             Positioned(
        //               left: cellConfig.rect.left,
        //               top: cellConfig.rect.top,
        //               child: Container(
        //                 height: cellConfig.rect.height,
        //                 constraints: BoxConstraints(minWidth: cellConfig.rect.width),
        //                 child: SheetTextField(cellConfig: cellConfig),
        //               ),
        //             )
        //         ],
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}