import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/values/actions/text_style_format_actions.dart';
import 'package:sheets/layers/cells/sheet_cells_layer.dart';
import 'package:sheets/layers/fill_handle/sheet_fill_handle_layer.dart';
import 'package:sheets/layers/headers/sheet_headers_layer.dart';
import 'package:sheets/layers/headers_resizer/sheet_headers_resizer_layer.dart';
import 'package:sheets/layers/selection/sheet_selection_layer.dart';
import 'package:sheets/layers/textfield/sheet_textfield_layer.dart';
import 'package:sheets/widgets/sheet_mouse_gesture_detector.dart';
import 'package:sheets/widgets/sheet_scrollable.dart';

class Sheet extends StatefulWidget {
  const Sheet({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetState extends State<Sheet> {
  SheetController get sheetController => widget.sheetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetKeyboardGestureDetector(
      focusNode: sheetController.sheetFocusNode,
      onSelectAll: () => sheetController.selection.update(SheetSelectionFactory.all()),
      onStartEditing: sheetController.startEditing,
      onMove: (CellMoveDirection direction) => sheetController.moveSelection(direction.toOffset()),
      onRemove: () => sheetController.clearSelection(),
      onFontWeightUpdate: (FontWeight fontWeight) => widget.sheetController.formatSelection(UpdateFontWeightAction(widget.sheetController.getSelectionStyle(), fontWeight)),
      onFontStyleUpdate: (FontStyle fontStyle) => widget.sheetController.formatSelection(UpdateFontStyleAction(widget.sheetController.getSelectionStyle(), fontStyle)),
      onTextDecorationUpdate: (TextDecoration decoration) => widget.sheetController.formatSelection(UpdateTextDecorationAction(widget.sheetController.getSelectionStyle(), decoration)),
      onUndo: () {},
      onRedo: () {},
      onPaste: () {},
      onCopy: () {},
      onCut: () {},
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xfff8faf8),
          ),
          child: SheetScrollable(
            scrollController: sheetController.scroll,
            child: SheetMouseGestureDetector(
              mouseListener: sheetController.mouse,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SheetContent(sheetController: sheetController);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class SheetContent extends StatefulWidget {
  const SheetContent({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => SheetContentState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class SheetContentState extends State<SheetContent> {
  final GlobalKey _sheetViewportKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySheetViewportChanged());
  }

  @override
  void didUpdateWidget(covariant SheetContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySheetViewportChanged());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _sheetViewportKey,
      child: SheetGrid(sheetController: widget.sheetController),
    );
  }

  void _notifySheetViewportChanged() {
    RenderBox? renderBox = _sheetViewportKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    Offset position = renderBox.localToGlobal(Offset.zero);
    widget.sheetController.viewport.setViewportRect(Rect.fromLTRB(
      position.dx,
      position.dy,
      renderBox.size.width + position.dx,
      renderBox.size.height + position.dy,
    ));
  }
}

class SheetGrid extends StatelessWidget {
  const SheetGrid({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned(
          bottom: 0,
          left: 50,
          height: 50,
          child: Row(
            children: <Widget>[
              Text('Add more'),
            ],
          ),
        ),
        Positioned.fill(child: SheetCellsLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetHeadersLayer(sheetController: sheetController)),
        Positioned.fill(child: HeadersResizerLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetSelectionLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetFillHandleLayer(sheetController: sheetController)),
        Positioned.fill(child: SheetTextfieldLayer(sheetController: sheetController)),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: rowHeadersWidth + 1,
            height: columnHeadersHeight + 1,
            decoration: const BoxDecoration(
              color: Color(0xfff8f9fa),
              border: Border(
                right: BorderSide(color: Color(0xffc7c7c7), width: 4),
                bottom: BorderSide(color: Color(0xffc7c7c7), width: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

enum CellMoveDirection {
  up,
  right,
  down,
  left;

  Offset toOffset() {
    return switch (this) {
      CellMoveDirection.up => const Offset(0, -1),
      CellMoveDirection.right => const Offset(1, 0),
      CellMoveDirection.down => const Offset(0, 1),
      CellMoveDirection.left => const Offset(-1, 0),
    };
  }
}

class _SheetKeyboardGestureDetector extends StatelessWidget {
  _SheetKeyboardGestureDetector({
    required this.focusNode,
    required this.child,
    required this.onSelectAll,
    required this.onStartEditing,
    required this.onMove,
    required this.onRemove,
    required this.onFontWeightUpdate,
    required this.onFontStyleUpdate,
    required this.onTextDecorationUpdate,
    required this.onUndo,
    required this.onRedo,
    required this.onPaste,
    required this.onCopy,
    required this.onCut,
  }) {
    // @formatter:off
    shortcuts = <ShortcutActivator, VoidCallback>{
      // Navigation
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () => onMove(CellMoveDirection.left),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () => onMove(CellMoveDirection.right),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => onMove(CellMoveDirection.up),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => onMove(CellMoveDirection.down),

      // Selection
      const SingleActivator(LogicalKeyboardKey.keyA, control: true): onSelectAll,
      // -- When shift is pressed, move the selection, as gesture recognizer checks it again to ensure the same behavior for mouse selection
      const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true): () => onMove(CellMoveDirection.left),
      const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true): () => onMove(CellMoveDirection.right),
      const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true): () => onMove(CellMoveDirection.up),
      const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true): () => onMove(CellMoveDirection.down),

      // Text manipulation
      const SingleActivator(LogicalKeyboardKey.backspace): onRemove,
      const SingleActivator(LogicalKeyboardKey.delete): onRemove,
      const SingleActivator(LogicalKeyboardKey.enter): onStartEditing,
      //
      // Formatting
      const SingleActivator(LogicalKeyboardKey.keyB, control: true): () => onFontWeightUpdate(FontWeight.bold),
      const SingleActivator(LogicalKeyboardKey.keyI, control: true): () => onFontStyleUpdate(FontStyle.italic),
      const SingleActivator(LogicalKeyboardKey.keyU, control: true): () => onTextDecorationUpdate(TextDecoration.underline),
      const SingleActivator(LogicalKeyboardKey.digit5, control: true, shift: true): () => onTextDecorationUpdate(TextDecoration.lineThrough),
      const SingleActivator(LogicalKeyboardKey.keyZ, control: true): onUndo,
      const SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true): onRedo,
      const SingleActivator(LogicalKeyboardKey.keyV, control: true): onPaste,
      const SingleActivator(LogicalKeyboardKey.keyC, control: true): onCopy,
      const SingleActivator(LogicalKeyboardKey.keyX, control: true): onCut,
    };
    // @formatter:on
  }

  final VoidCallback onSelectAll;
  final void Function([String? initialValue]) onStartEditing;
  final ValueChanged<CellMoveDirection> onMove;
  final VoidCallback onRemove;
  final ValueChanged<FontWeight> onFontWeightUpdate;
  final ValueChanged<FontStyle> onFontStyleUpdate;
  final ValueChanged<TextDecoration> onTextDecorationUpdate;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onPaste;
  final VoidCallback onCopy;
  final VoidCallback onCut;

  final Widget child;
  final FocusNode focusNode;
  late final Map<ShortcutActivator, VoidCallback> shortcuts;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<ShortcutActivator, VoidCallback>>('shortcuts', shortcuts));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSelectAll', onSelectAll));
    properties.add(ObjectFlagProperty<void Function([String? initialValue])>.has('onStartEditing', onStartEditing));
    properties.add(ObjectFlagProperty<ValueChanged<CellMoveDirection>>.has('onMove', onMove));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onRemove', onRemove));
    properties.add(ObjectFlagProperty<ValueChanged<FontWeight>>.has('onFontWeightUpdate', onFontWeightUpdate));
    properties.add(ObjectFlagProperty<ValueChanged<FontStyle>>.has('onFontStyleUpdate', onFontStyleUpdate));
    properties.add(ObjectFlagProperty<ValueChanged<TextDecoration>>.has('onTextDecorationUpdate', onTextDecorationUpdate));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onUndo', onUndo));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onRedo', onRedo));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPaste', onPaste));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCopy', onCopy));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCut', onCut));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        focusNode: focusNode,
        onKeyEvent: _handleKeyEvent,
        child: MouseRegion(
          cursor: SystemMouseCursors.text,
          child: child,
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode focus, KeyEvent event) {
    for (ShortcutActivator activator in shortcuts.keys) {
      if (activator.accepts(event, HardwareKeyboard.instance)) {
        shortcuts[activator]?.call();
        return KeyEventResult.handled;
      }
    }

    if (event.character != null && event.character!.isNotEmpty) {
      onStartEditing(event.character);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
