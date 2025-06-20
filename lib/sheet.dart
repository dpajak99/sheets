import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/events/sheet_clipboard_events.dart';
import 'package:sheets/core/events/sheet_event.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/events/sheet_selection_events.dart';
import 'package:sheets/core/selection/sheet_selection_factory.dart';
import 'package:sheets/core/viewport/viewport_item.dart';
import 'package:sheets/core/worksheet.dart';
import 'package:sheets/layers/fill_handle/sheet_fill_handle_layer.dart';
import 'package:sheets/layers/headers_resizer/sheet_headers_resizer_layer.dart';
import 'package:sheets/layers/pin_area/sheet_pin_area_layer.dart';
import 'package:sheets/layers/sheet/sheet_layer.dart';
import 'package:sheets/layers/textfield/sheet_textfield_layer.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/goog/menu/context/goog_cell_context_menu.dart';
import 'package:sheets/widgets/goog/menu/context/goog_column_context_menu.dart';
import 'package:sheets/widgets/goog/menu/context/goog_row_context_menu.dart';
import 'package:sheets/widgets/popup/sheet_popup.dart';
import 'package:sheets/widgets/sheet_cursor_wrapper.dart';
import 'package:sheets/widgets/sheet_scrollable.dart';

class SheetCursor extends ChangeNotifier {
  SheetCursor._();

  static final SheetCursor instance = SheetCursor._();

  SystemMouseCursor? _value;
  Key? _pressedKey;

  Offset position = Offset.zero;

  void set(SystemMouseCursor cursor) {
    _value = cursor;
    notifyListeners();
  }

  void reset() {
    _value = null;
    notifyListeners();
  }

  void notifyKeyPressed(Key key) {
    _pressedKey = key;
  }

  void notifyKeyReleased() {
    _pressedKey = null;
  }

  bool get isPressed => _pressedKey != null;

  SystemMouseCursor get value => _value ?? SystemMouseCursors.basic;
}

class Sheet extends StatefulWidget {
  const Sheet({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => _SheetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class _SheetState extends State<Sheet> {
  Worksheet get worksheet => widget.worksheet;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SheetCursorWrapper(
      child: _SheetKeyboardGestureDetector(
        focusNode: worksheet.sheetFocusNode,
        onSelectAll: () => worksheet.selection.update(SheetSelectionFactory.all()),
        onStartEditing: ([String? initialValue]) => worksheet.resolve(EnableEditingEvent(initialValue: initialValue)),
        onMove: (CellMoveDirection direction) => worksheet.resolve(MoveSelectionEvent.fromOffset(direction.toOffset())),
        onRemove: () => worksheet.resolve(ClearSelectionEvent()),
        onFontWeightUpdate: (FontWeight fontWeight) =>
            widget.worksheet.resolve(FormatSelectionEvent(ToggleFontWeightIntent())),
        onFontStyleUpdate: (FontStyle fontStyle) => widget.worksheet.resolve(FormatSelectionEvent(ToggleFontStyleIntent())),
        onTextDecorationUpdate: (TextDecoration decoration) =>
            widget.worksheet.resolve(FormatSelectionEvent(ToggleTextDecorationIntent(value: decoration))),
        onUndo: () {},
        onRedo: () {},
        onPaste: () {
          widget.worksheet.resolve(PasteSelectionEvent());
        },
        onPasteValues: () {
          widget.worksheet.resolve(PasteSelectionEvent(valuesOnly: true));
        },
        onCopy: () {
          widget.worksheet.resolve(CopySelectionEvent());
        },
        onCut: () {
          widget.worksheet.resolve(CutSelectionEvent());
        },
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xfff8faf8),
            ),
            child: SheetScrollable(
              worksheet: worksheet,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SheetContent(worksheet: worksheet);
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
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }
}

class SheetContent extends StatefulWidget {
  const SheetContent({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

  @override
  State<StatefulWidget> createState() => SheetContentState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
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
      child: SheetGrid(worksheet: widget.worksheet),
    );
  }

  void _notifySheetViewportChanged() {
    RenderBox? renderBox = _sheetViewportKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return;
    }

    Offset position = renderBox.localToGlobal(Offset.zero);
    widget.worksheet.resolve(SetViewportSizeEvent(Rect.fromLTRB(
      position.dx,
      position.dy,
      renderBox.size.width + position.dx,
      renderBox.size.height + position.dy,
    )));
  }
}

class SheetGrid extends StatelessWidget {
  const SheetGrid({
    required this.worksheet,
    super.key,
  });

  final Worksheet worksheet;

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
        Positioned.fill(
          child: SheetLayer(
            worksheet: worksheet,
            onDragStart: (ViewportItem viewportItem) => worksheet.resolve(StartSelectionEvent(viewportItem)),
            onDragUpdate: (ViewportItem viewportItem) => worksheet.resolve(UpdateSelectionEvent(viewportItem)),
            onDragEnd: () => worksheet.resolve(CompleteSelectionEvent()),
            onSecondaryPointerTap: (ViewportItem item) => _openContextMenuFor(context, item),
            onDoubleTap: (ViewportItem viewportItem) =>
                worksheet.resolve(EnableEditingEvent(cell: viewportItem.index.toCellIndex())),
          ),
        ),
        Positioned.fill(child: HeadersResizerLayer(worksheet: worksheet)),
        Positioned.fill(child: SheetPinAreaLayer(worksheet: worksheet)),
        Positioned.fill(child: SheetFillHandleLayer(worksheet: worksheet)),
        Positioned.fill(child: SheetTextfieldLayer(worksheet: worksheet)),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Worksheet>('worksheet', worksheet));
  }

  void _openContextMenuFor(BuildContext context, ViewportItem viewportItem) {
    Widget? popupWidget = switch (viewportItem) {
      ViewportCell _ => const GoogCellContextMenu(),
      ViewportColumn _ => const GoogColumnContextMenu(),
      ViewportRow _ => const GoogRowContextMenu(),
      (_) => null,
    };

    if (popupWidget == null) {
      return;
    }

    SheetPopup.openGlobalPopup(
      context,
      0,
      SheetCursor.instance.position,
      (_) => popupWidget,
    );
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
    required this.onPasteValues,
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
      const SingleActivator(LogicalKeyboardKey.keyV, control: true, shift: true): onPasteValues,
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
  final VoidCallback onPasteValues;
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
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPasteValues', onPasteValues));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        focusNode: focusNode,
        onKeyEvent: _handleKeyEvent,
        child: child,
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
