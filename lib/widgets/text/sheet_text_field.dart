import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/core/config/sheet_constants.dart' as constants;
import 'package:sheets/utils/extensions/silent_value_notifier.dart';
import 'package:sheets/utils/formatters/style/double_extensions.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/text/sheet_text_field_actions.dart';

/// Represents a single character with an associated [TextStyle].
class TextSpanLetter with EquatableMixin {
  TextSpanLetter({required this.letter, required this.style})
      : assert(
          letter.isEmpty || letter.length == 1,
          'Letter must be empty or have a length of 1',
        );

  TextSpanLetter.empty({required this.style}) : letter = '';

  final TextStyle style;
  final String letter;

  TextSpanLetter copyWith({
    String? letter,
    TextStyle? style,
  }) {
    return TextSpanLetter(
      letter: letter ?? this.letter,
      style: style ?? this.style,
    );
  }

  bool get isEmpty => letter.isEmpty;

  @override
  List<Object?> get props => <Object?>[letter, style];
}

/// Manages the text content composed of [TextSpanLetter]s and provides methods
/// for text manipulation and formatting.
class EditableTextSpan with EquatableMixin {
  EditableTextSpan({required this.letters});

  factory EditableTextSpan.fromTextSpan(TextSpan textSpan) {
    List<TextSpanLetter> letters = <TextSpanLetter>[];
    textSpan.visitChildren((InlineSpan span) {
      if (span is TextSpan) {
        List<String> text = span.text?.split('') ?? <String>[];
        for (String letter in text) {
          letters.add(TextSpanLetter(letter: letter, style: span.style!));
        }
      }
      return true;
    });

    if (letters.isEmpty) {
      List<TextSpan> childrenSpans = textSpan.children!.cast<TextSpan>();
      TextStyle existingStyle = childrenSpans.first.style!;
      letters.add(TextSpanLetter(letter: '', style: existingStyle));
    }

    EditableTextSpan editableTextSpan = EditableTextSpan(letters: letters);
    return editableTextSpan;
  }

  final List<TextSpanLetter> letters;

  EditableTextSpan copyWith({
    List<TextSpanLetter>? letters,
    TextStyle? defaultTextStyle,
  }) {
    return EditableTextSpan(letters: letters ?? this.letters);
  }

  EditableTextSpan clear({bool keepStyle = false}) {
    TextStyle style = keepStyle ? letters.first.style : constants.defaultTextStyle;
    return copyWith(letters: <TextSpanLetter>[TextSpanLetter(letter: '', style: style)]);
  }

  EditableTextSpan format({required int start, required int end, required TextStyleFormatIntent intent}) {
    List<TextSpanLetter> updatedLetters = List<TextSpanLetter>.from(letters);
    List<TextStyle> styles = updatedLetters.sublist(start, end).map((TextSpanLetter letter) => letter.style).toList();
    if (styles.isEmpty) {
      return this;
    }
    TextStyle mergedStyle = styles.length > 1
        ? styles.reduce((TextStyle a, TextStyle b) => a.merge(b)) //
        : styles.first;

    TextStyleFormatAction<TextStyleFormatIntent> formatter = intent.createAction(baseTextStyle: mergedStyle);

    for (int i = start; i < end; i++) {
      TextStyle newStyle = formatter.format(letters[i].style);
      updatedLetters[i] = updatedLetters[i].copyWith(style: newStyle);
    }

    return copyWith(letters: updatedLetters);
  }

  EditableTextSpan insert(int index, String text) {
    List<TextSpanLetter> updatedLetters = List<TextSpanLetter>.from(letters);
    TextStyle previousStyle = getPreviousStyle(index);
    List<TextSpanLetter> newLetters = text.characters.map((String letter) {
      return TextSpanLetter(letter: letter, style: previousStyle);
    }).toList();

    if (index >= 0 && index <= updatedLetters.length) {
      updatedLetters.insertAll(index, newLetters);
    }
    return copyWith(letters: updatedLetters);
  }

  EditableTextSpan removeRange(int start, int end) {
    List<TextSpanLetter> updatedLetters = List<TextSpanLetter>.from(letters);

    if (start >= 0 && end <= updatedLetters.length && start < end) {
      updatedLetters.removeRange(start, end);
    }
    if (updatedLetters.isEmpty) {
      updatedLetters.add(TextSpanLetter(letter: '', style: letters.first.style));
    }
    return copyWith(letters: updatedLetters);
  }

  String get rawText {
    return letters.map((TextSpanLetter letter) => letter.letter).join();
  }

  int get length {
    List<TextSpanLetter> notEmptyLetters = letters.where((TextSpanLetter letter) => letter.letter.isNotEmpty).toList();
    return notEmptyLetters.length;
  }

  TextSpan toTextSpan({TextRangeStyleModifier? styleModifier}) {
    List<TextSpanLetter> modifiedLetters = List<TextSpanLetter>.from(letters);
    if (styleModifier != null) {
      for (int i = styleModifier.start; i < styleModifier.end; i++) {
        if (i >= 0 && i < modifiedLetters.length) {
          TextStyle modifiedStyle = styleModifier.modifier(modifiedLetters[i].style);
          modifiedLetters[i] = modifiedLetters[i].copyWith(style: modifiedStyle);
        }
      }
    }

    List<TextSpan> spans = <TextSpan>[];
    if (modifiedLetters.isEmpty) {
      return TextSpan(text: '', children: spans, style: letters.first.style);
    }

    TextStyle currentStyle = modifiedLetters.first.style;
    StringBuffer buffer = StringBuffer();

    for (TextSpanLetter letter in modifiedLetters) {
      if (letter.style == currentStyle) {
        buffer.write(letter.letter);
      } else {
        spans.add(TextSpan(text: buffer.toString(), style: currentStyle));
        currentStyle = letter.style;
        buffer = StringBuffer(letter.letter);
      }
    }

    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString(), style: currentStyle));
    }

    return TextSpan(text: '', children: spans, style: letters.first.style);
  }

  TextStyle getPreviousStyle(int index) {
    late TextStyle previousStyle;
    if (index > 0 && index <= letters.length) {
      previousStyle = letters[index - 1].style;
    } else {
      previousStyle = letters.first.style;
    }

    return previousStyle;
  }

  @override
  List<Object?> get props => <Object?>[letters];
}

/// Represents a style modifier applied over a range of text.
class TextRangeStyleModifier with EquatableMixin {
  TextRangeStyleModifier({
    required this.start,
    required this.end,
    required this.modifier,
  });

  final int start;
  final int end;
  final TextStyle Function(TextStyle style) modifier;

  @override
  List<Object?> get props => <Object?>[start, end, modifier];
}

/// Encapsulates the text value and selection state.
class SheetTextEditingValue with EquatableMixin {
  SheetTextEditingValue({
    required this.text,
    required this.selection,
  }) : span = text.toTextSpan();

  final EditableTextSpan text;
  final TextSelection selection;
  final TextSpan span;

  static SheetTextEditingValue empty = SheetTextEditingValue(
    text: EditableTextSpan(letters: <TextSpanLetter>[TextSpanLetter(letter: '', style: constants.defaultTextStyle)]),
    selection: const TextSelection.collapsed(offset: 0),
  );

  SheetTextEditingValue copyWith({
    EditableTextSpan? text,
    TextSelection? selection,
  }) {
    return SheetTextEditingValue(
      text: text ?? this.text,
      selection: selection ?? this.selection,
    );
  }

  int get length => text.length;

  @override
  List<Object?> get props => <Object?>[text, selection];
}

/// Manages undo and redo operations.
class _HistoryManager<T> {
  final List<T> _undoStack = <T>[];
  final List<T> _redoStack = <T>[];

  void save(T state) {
    _undoStack.add(state);
    _redoStack.clear();
  }

  T? undo(T currentState) {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(currentState);
      return _undoStack.removeLast();
    }
    return null;
  }

  T? redo(T currentState) {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(currentState);
      return _redoStack.removeLast();
    }
    return null;
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}

class SheetTextfieldState {
  SheetTextfieldState._(this.painter, this.lines);

  factory SheetTextfieldState.fromPainter(TextPainter painter) {
    return SheetTextfieldState._(
      painter,
      painter.computeLineMetrics(),
    );
  }

  static SheetTextfieldState empty = SheetTextfieldState._(
    TextPainter(text: const TextSpan(text: ' ', style: constants.defaultTextStyle)),
    <LineMetrics>[],
  );

  final TextPainter painter;
  final List<LineMetrics> lines;

  int get linesCount => lines.length;

  int getNextWordBoundary(int offset) {
    TextPosition position = TextPosition(offset: offset);
    TextRange word = painter.getWordBoundary(position);
    return word.end;
  }

  int getPreviousWordBoundary(int offset) {
    TextPosition position = TextPosition(offset: offset - 1);
    TextRange word = painter.getWordBoundary(position);
    return word.start;
  }

  int getLineIndexForOffset(double dy) {
    double cumulativeHeight = 0;

    for (int i = 0; i < lines.length; i++) {
      cumulativeHeight += lines[i].height;
      if (dy < cumulativeHeight) {
        return i;
      }
    }
    return max(lines.length - 1, 0);
  }

  /// Returns the text position at the given [offset].
  TextPosition getPressedPosition(Offset offset) {
    return painter.getPositionForOffset(offset);
  }
}

/// Controller for the custom text editor, handling text manipulation,
/// selection, formatting, and cursor management.
class SheetTextEditingController extends ValueNotifier<SheetTextEditingValue> {
  factory SheetTextEditingController({
    EditableTextSpan? text,
    TextAlign textAlign = TextAlign.left,
  }) {
    SheetTextEditingValue value = text != null
        ? SheetTextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length))
        : SheetTextEditingValue.empty;

    return SheetTextEditingController._(value, textAlign: textAlign);
  }

  SheetTextEditingController._(super._value, {this.textAlign = TextAlign.left});

  final TextAlign textAlign;
  final _HistoryManager<SheetTextEditingValue> _historyManager = _HistoryManager<SheetTextEditingValue>();

  late double minWidth;
  late double minHeight;
  late double maxWidth;
  late double maxHeight;
  late double? step;
  final SilentValueNotifier<Size> sizeNotifier = SilentValueNotifier<Size>(Size.zero);

  late SheetTextfieldState state = SheetTextfieldState.empty;

  void layout({
    required double minWidth,
    required double minHeight,
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
    double? step,
  }) {
    this.minWidth = minWidth;
    this.minHeight = minHeight;
    this.maxWidth = maxWidth;
    this.maxHeight = maxHeight;
    this.step = step;
    sizeNotifier.setValue(Size(minWidth, minHeight), notify: false);

    _updateTextPainter();
  }

  @override
  void notifyListeners() {
    _updateTextPainter();
    super.notifyListeners();
  }

  Size get size => sizeNotifier.value;

  TextSelection get selection => value.selection;

  int get length => value.length;

  bool get cursorAtStart {
    return value.selection.start == 0;
  }

  bool get cursorAtEnd {
    return value.selection.end == value.text.length;
  }

  bool get isAllSelected {
    return cursorAtStart && cursorAtEnd;
  }

  /// Returns the style of the character preceding the cursor.
  TextStyle get previousStyle {
    int index = value.selection.start;
    return value.text.getPreviousStyle(index);
  }

  List<TextStyle> get selectionStyles {
    List<TextStyle> styles = <TextStyle>[];
    for (int i = selection.start; i < selection.end; i++) {
      styles.add(value.text.letters[i].style);
    }
    return styles;
  }

  Future<void> handleAction(SheetTextFieldAction action) async {
    SheetTextEditingValue oldValue = value;
    SheetTextEditingValue newValue = await action.execute(this);
    if (action.shouldUpdateHistory) {
      _saveToHistory();
    }
    if (oldValue.text != newValue.text) {
      _updateTextPainter();
    }

    value = newValue;
  }

  void _updateTextPainter() {
    _updateTextFieldSize();
    TextPainter textPainter = buildTextPainter(value.span);
    state = SheetTextfieldState.fromPainter(textPainter);
  }

  void _updateTextFieldSize() {
    Size newSize = _calculateTextfieldSize(sizeNotifier.value);
    sizeNotifier.setValue(newSize);
  }

  Size _calculateTextfieldSize(Size previousSize) {
    double updatedWidth = _calculateTextfieldWidth(previousSize.width);
    double updatedHeight = _calculateTextfieldHeight(previousSize.height, updatedWidth);

    return Size(updatedWidth, updatedHeight);
  }

  double _calculateTextfieldWidth(double previousWidth) {
    TextPainter painter = buildTextPainter(value.span, customWidth: previousWidth, useMinWidth: false);

    double updatedWidth = previousWidth.safeClamp(minWidth, maxWidth);

    bool expandPossible = previousWidth < maxWidth && step != null;
    bool expandNeeded = previousWidth <= painter.width;

    if(expandNeeded && step == null) {
      return painter.width.safeClamp(minWidth, maxWidth);
    } else if (expandPossible && expandNeeded) {
      return _calculateTextfieldWidth(updatedWidth + (textAlign == TextAlign.center ? step! * 2 : step!));
    } else {
      return updatedWidth.safeClamp(minWidth, maxWidth);
    }
  }

  double _calculateTextfieldHeight(double previousHeight, double width) {
    TextSpan span = value.span;
    if (span.toPlainText().isEmpty) {
      span = TextSpan(text: ' ', style: previousStyle);
    }

    TextPainter painter = buildTextPainter(span, customWidth: width, useMinWidth: false);
    if (previousHeight < maxHeight) {
      return painter.height.safeClamp(minHeight, maxHeight);
    } else {
      return previousHeight.safeClamp(minHeight, maxHeight);
    }
  }

  /// Builds and returns a [TextPainter] for the current text.
  TextPainter buildTextPainter(TextSpan textSpan, {double? customWidth, bool useMinWidth = true}) {
    TextPainter painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
    );
    double width = customWidth ?? size.width;
    painter.layout(minWidth: useMinWidth ? width : 0, maxWidth: width);
    return painter;
  }

  /// Performs undo operation.
  void undo() {
    SheetTextEditingValue? previousValue = _historyManager.undo(value);
    if (previousValue != null) {
      value = previousValue;
      notifyListeners();
    }
  }

  /// Performs redo operation.
  void redo() {
    SheetTextEditingValue? nextValue = _historyManager.redo(value);
    if (nextValue != null) {
      value = nextValue;
      notifyListeners();
    }
  }

  void _saveToHistory() {
    _historyManager.save(
      value.copyWith(
        text: EditableTextSpan(letters: List<TextSpanLetter>.from(value.text.letters)),
      ),
    );
  }
}

class SheetTextField extends StatefulWidget {
  const SheetTextField({
    required this.controller,
    required this.focusNode,
    required this.onSizeChanged,
    required this.onCompleted,
    this.backgroundColor = Colors.white,
    super.key,
  });

  final SheetTextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<Size> onSizeChanged;
  final void Function(bool shouldSaveValue, TextSpan textSpan, Size size) onCompleted;
  final Color backgroundColor;

  @override
  State<SheetTextField> createState() => _SheetTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetTextEditingController>('controller', controller));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ObjectFlagProperty<ValueChanged<Size>>.has('onSizeChanged', onSizeChanged));
    properties.add(
        ObjectFlagProperty<void Function(bool shouldSaveValue, TextSpan textSpan, Size size)>.has('onCompleted', onCompleted));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
  }
}

class _SheetTextFieldState extends State<SheetTextField> {
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.sizeNotifier.addListener(_handleSizeChange);
    widget.focusNode.addListener(_autocompleteEditing);
    _handleSizeChange();
  }

  @override
  void dispose() {
    widget.controller.sizeNotifier.removeListener(_handleSizeChange);
    widget.focusNode.removeListener(_autocompleteEditing);
    super.dispose();
  }

  void _autocompleteEditing() {
    if (!widget.focusNode.hasFocus && !_completed) {
      _complete(true);
    }
  }

  void _handleSizeChange() {
    widget.onSizeChanged(widget.controller.sizeNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return _SheetKeyboardGestureDetector(
      focusNode: widget.focusNode,
      onCursorMove: _moveCursor,
      onExpandSelection: (CursorMoveDirection direction) => _moveCursor(direction, expandSelection: true),
      onSelectAll: _selectAll,
      onRemoveText: _remove,
      onInsertText: _insertText,
      onCompleted: _complete,
      onCopy: _copy,
      onCut: _cut,
      onPaste: _paste,
      onUndo: _undo,
      onRedo: _redo,
      onFontWeightUpdate: _updateFontWeight,
      onFontStyleUpdate: _updateFontStyle,
      onTextDecorationUpdate: _formatDecoration,
      child: _SheetMouseGestureDetector(
        controller: widget.controller,
        onSelectIndex: _selectIndexByOffset,
        onSelectWord: _selectWordByOffset,
        onSelectAll: _selectAll,
        onExtendSelection: _expandSelectionByOffset,
        child: Stack(
          children: <Widget>[
            ValueListenableBuilder<Size>(
              valueListenable: widget.controller.sizeNotifier,
              builder: (BuildContext context, Size size, _) {
                return Container(width: size.width, height: size.height, color: widget.backgroundColor);
              },
            ),
            RepaintBoundary(
              child: CustomPaint(painter: _SelectionPainter(widget.controller)),
            ),
            RepaintBoundary(
              child: CustomPaint(painter: _LettersPainter(widget.controller)),
            ),
            RepaintBoundary(
              child: CustomPaint(painter: _CursorPainter(widget.controller)),
            ),
          ],
        ),
      ),
    );
  }

  void _moveCursor(CursorMoveDirection direction, {bool expandSelection = false}) {
    SheetTextFieldAction action = switch (direction) {
      CursorMoveDirection.indexLeft => SheetTextFieldActions.moveCursor(const Offset(-1, 0), expandSelection: expandSelection),
      CursorMoveDirection.indexRight => SheetTextFieldActions.moveCursor(const Offset(1, 0), expandSelection: expandSelection),
      CursorMoveDirection.indexUp => SheetTextFieldActions.moveCursor(const Offset(0, -1), expandSelection: expandSelection),
      CursorMoveDirection.indexDown => SheetTextFieldActions.moveCursor(const Offset(0, 1), expandSelection: expandSelection),
      CursorMoveDirection.wordLeft => SheetTextFieldActions.moveCursorByWord(-1, expandSelection: expandSelection),
      CursorMoveDirection.wordRight => SheetTextFieldActions.moveCursorByWord(1, expandSelection: expandSelection),
    };

    _handleAction(action);
  }

  void _remove(TextRemoveDirection direction) {
    SheetTextFieldAction action = switch (direction) {
      TextRemoveDirection.indexLeft => SheetTextFieldActions.removeText(-1),
      TextRemoveDirection.indexRight => SheetTextFieldActions.removeText(1),
      TextRemoveDirection.wordLeft => SheetTextFieldActions.removeWord(-1),
      TextRemoveDirection.wordRight => SheetTextFieldActions.removeWord(1),
    };

    _handleAction(action);
  }

  void _selectIndexByOffset(Offset offset) {
    _handleAction(SheetTextFieldActions.selectByOffset(offset));
  }

  void _selectWordByOffset(Offset offset) {
    _handleAction(SheetTextFieldActions.selectWordByOffset(offset));
  }

  void _expandSelectionByOffset(Offset offset, bool selectWords) {
    _handleAction(SheetTextFieldActions.extendSelectionByOffset(offset, selectWords: selectWords));
  }

  void _selectAll() {
    _handleAction(SheetTextFieldActions.selectAll());
  }

  void _updateFontWeight(FontWeight fontWeight) {
    _handleAction(SheetTextFieldActions.format(ToggleFontWeightIntent(value: fontWeight)));
  }

  void _updateFontStyle(FontStyle fontStyle) {
    _handleAction(SheetTextFieldActions.format(ToggleFontStyleIntent(value: fontStyle)));
  }

  void _formatDecoration(TextDecoration textDecoration) {
    _handleAction(SheetTextFieldActions.format(ToggleTextDecorationIntent(value: textDecoration)));
  }

  void _undo() {
    widget.controller.undo();
  }

  void _redo() {
    widget.controller.redo();
  }

  void _complete(bool shouldSaveValue) {
    _completed = true;
    Size size = widget.controller.sizeNotifier.value;
    TextSpan textSpan = widget.controller.value.text.toTextSpan();
    widget.onCompleted(shouldSaveValue, textSpan, size);
  }

  void _copy() {
    _handleAction(SheetTextFieldActions.copy());
  }

  void _cut() {
    _handleAction(SheetTextFieldActions.cut());
  }

  void _paste() {
    _handleAction(SheetTextFieldActions.paste());
  }

  void _insertText(String text) {
    _handleAction(SheetTextFieldActions.insertText(text));
  }

  void _handleAction(SheetTextFieldAction action) {
    unawaited(widget.controller.handleAction(action));
  }
}

enum CursorMoveDirection { indexLeft, indexRight, indexUp, indexDown, wordLeft, wordRight }

enum TextRemoveDirection { indexLeft, indexRight, wordLeft, wordRight }

class _SheetKeyboardGestureDetector extends StatelessWidget {
  _SheetKeyboardGestureDetector({
    required this.child,
    required this.focusNode,
    required this.onCursorMove,
    required this.onSelectAll,
    required this.onExpandSelection,
    required this.onRemoveText,
    required this.onInsertText,
    required this.onCompleted,
    required this.onCopy,
    required this.onCut,
    required this.onPaste,
    required this.onUndo,
    required this.onRedo,
    required this.onFontWeightUpdate,
    required this.onFontStyleUpdate,
    required this.onTextDecorationUpdate,
  }) {
    // @formatter:off
    shortcuts = <ShortcutActivator, VoidCallback>{
      // Navigation
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
        onCursorMove(CursorMoveDirection.indexLeft);
      },
      const SingleActivator(LogicalKeyboardKey.arrowLeft, control: true): () => onCursorMove(CursorMoveDirection.wordLeft),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () => onCursorMove(CursorMoveDirection.indexRight),
      const SingleActivator(LogicalKeyboardKey.arrowRight, control: true): () => onCursorMove(CursorMoveDirection.wordRight),
      const SingleActivator(LogicalKeyboardKey.arrowUp): () => onCursorMove(CursorMoveDirection.indexUp),
      const SingleActivator(LogicalKeyboardKey.arrowUp, control: true): () => onCursorMove(CursorMoveDirection.indexUp),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () => onCursorMove(CursorMoveDirection.indexDown),
      const SingleActivator(LogicalKeyboardKey.arrowDown, control: true): () => onCursorMove(CursorMoveDirection.indexDown),

      // Selection
      const SingleActivator(LogicalKeyboardKey.keyA, control: true): onSelectAll,
      const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true): () => onExpandSelection(CursorMoveDirection.indexLeft),
      const SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true, control: true): () => onExpandSelection(CursorMoveDirection.wordLeft),
      const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true): () => onExpandSelection(CursorMoveDirection.indexRight),
      const SingleActivator(LogicalKeyboardKey.arrowRight, shift: true, control: true): () => onExpandSelection(CursorMoveDirection.wordRight),
      const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true): () => onExpandSelection(CursorMoveDirection.indexUp),
      const SingleActivator(LogicalKeyboardKey.arrowUp, shift: true, control: true): () => onExpandSelection(CursorMoveDirection.indexUp),
      const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true): () => onExpandSelection(CursorMoveDirection.indexDown),
      const SingleActivator(LogicalKeyboardKey.arrowDown, shift: true, control: true): () => onExpandSelection(CursorMoveDirection.indexDown),

      // Text manipulation
      const SingleActivator(LogicalKeyboardKey.backspace): () => onRemoveText(TextRemoveDirection.indexLeft),
      const SingleActivator(LogicalKeyboardKey.backspace, control: true): () => onRemoveText(TextRemoveDirection.wordLeft),
      const SingleActivator(LogicalKeyboardKey.delete): () => onRemoveText(TextRemoveDirection.indexRight),
      const SingleActivator(LogicalKeyboardKey.delete, control: true): () => onRemoveText(TextRemoveDirection.wordRight),
      const SingleActivator(LogicalKeyboardKey.enter, control: true): () => onInsertText('\n'),
      const SingleActivator(LogicalKeyboardKey.enter): () => onCompleted(true),
      const SingleActivator(LogicalKeyboardKey.escape): () => onCompleted(false),

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

  final Widget child;
  final FocusNode focusNode;
  final ValueChanged<CursorMoveDirection> onCursorMove;
  final VoidCallback onSelectAll;
  final ValueChanged<CursorMoveDirection> onExpandSelection;
  final ValueChanged<TextRemoveDirection> onRemoveText;
  final ValueChanged<String> onInsertText;
  final void Function(bool shouldSaveValue) onCompleted;
  final VoidCallback onCopy;
  final VoidCallback onCut;
  final VoidCallback onPaste;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<FontWeight> onFontWeightUpdate;
  final ValueChanged<FontStyle> onFontStyleUpdate;
  final ValueChanged<TextDecoration> onTextDecorationUpdate;
  late final Map<ShortcutActivator, VoidCallback> shortcuts;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: true,
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
      onInsertText(event.character!);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<CursorMoveDirection>>.has('onCursorMove', onCursorMove));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSelectAll', onSelectAll));
    properties.add(ObjectFlagProperty<ValueChanged<CursorMoveDirection>>.has('onExpandSelection', onExpandSelection));
    properties.add(ObjectFlagProperty<ValueChanged<TextRemoveDirection>>.has('onRemoveText', onRemoveText));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onInsertText', onInsertText));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCopy', onCopy));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onCut', onCut));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPaste', onPaste));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onUndo', onUndo));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onRedo', onRedo));
    properties.add(ObjectFlagProperty<ValueChanged<FontWeight>>.has('onFontWeightUpdate', onFontWeightUpdate));
    properties.add(ObjectFlagProperty<ValueChanged<FontStyle>>.has('onFontStyleUpdate', onFontStyleUpdate));
    properties.add(ObjectFlagProperty<ValueChanged<TextDecoration>>.has('onTextDecorationUpdate', onTextDecorationUpdate));
    properties.add(DiagnosticsProperty<Map<ShortcutActivator, VoidCallback>>('shortcuts', shortcuts));
    properties.add(ObjectFlagProperty<void Function(bool shouldSaveValue)>.has('onCompleted', onCompleted));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
  }
}

class _SheetMouseGestureDetector extends StatefulWidget {
  const _SheetMouseGestureDetector({
    required this.controller,
    required this.child,
    required this.onSelectIndex,
    required this.onSelectWord,
    required this.onSelectAll,
    required this.onExtendSelection,
  });

  final SheetTextEditingController controller;
  final Widget child;
  final ValueChanged<Offset> onSelectIndex;
  final ValueChanged<Offset> onSelectWord;
  final VoidCallback onSelectAll;
  final void Function(Offset offset, bool selectWords) onExtendSelection;

  @override
  State<StatefulWidget> createState() => _SheetMouseGestureDetectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetTextEditingController>('controller', controller));
    properties.add(ObjectFlagProperty<ValueChanged<Offset>>.has('onSelectIndex', onSelectIndex));
    properties.add(ObjectFlagProperty<ValueChanged<Offset>>.has('onSelectWord', onSelectWord));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSelectAll', onSelectAll));
    properties
        .add(ObjectFlagProperty<void Function(Offset offset, bool selectWords)>.has('onExtendSelection', onExtendSelection));
  }
}

class _SheetMouseGestureDetectorState extends State<_SheetMouseGestureDetector> {
  _PressedTextPosition _lastPressedPosition = _PressedTextPosition.empty;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        child: widget.child,
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    TextPosition pressedPosition = widget.controller.state.getPressedPosition(event.localPosition);
    _PressedTextPosition pressedTextPosition = _lastPressedPosition.derive(pressedPosition);

    if (pressedTextPosition.isFirstPress) {
      widget.onSelectIndex(event.localPosition);
    } else if (pressedTextPosition.isSecondPress) {
      widget.onSelectWord(event.localPosition);
    } else if (pressedTextPosition.isThirdPress) {
      widget.onSelectAll();
    }
    _lastPressedPosition = pressedTextPosition;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    widget.onExtendSelection(event.localPosition, _lastPressedPosition.isSecondPress);
  }
}

class _PressedTextPosition with EquatableMixin {
  _PressedTextPosition._(this.tapCount, this.textPosition) : lastPressTime = DateTime.now();
  final int tapCount;
  final TextPosition? textPosition;
  final DateTime lastPressTime;

  static _PressedTextPosition empty = _PressedTextPosition._(0, null);

  _PressedTextPosition derive(TextPosition textPosition) {
    if (pressTimeExpired) {
      return _PressedTextPosition._(1, textPosition);
    }

    if (this.textPosition == textPosition && tapCount < 3) {
      return _PressedTextPosition._(tapCount + 1, textPosition);
    } else {
      return _PressedTextPosition._(1, textPosition);
    }
  }

  bool get isFirstPress {
    return tapCount == 1;
  }

  bool get isSecondPress {
    return !pressTimeExpired && tapCount == 2;
  }

  bool get isThirdPress {
    return !pressTimeExpired && tapCount == 3;
  }

  bool get pressTimeExpired {
    return DateTime.now().difference(lastPressTime) > const Duration(milliseconds: 500);
  }

  @override
  List<Object?> get props => <Object?>[tapCount, textPosition];
}

class _SelectionPainter extends ChangeNotifier implements CustomPainter {
  _SelectionPainter(this._controller) {
    _controller.addListener(notifyListeners);
  }

  final SheetTextEditingController _controller;

  @override
  bool? hitTest(Offset position) {
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, _controller.size.width, _controller.size.height));

    TextSelection selection = _controller.value.selection;
    if (selection.isCollapsed) {
      return;
    }

    Paint paint = Paint()..color = const Color(0xff3367d1);

    List<TextBox> boxes = _controller.state.painter.getBoxesForSelection(selection);
    List<LineMetrics> lineMetrics = _controller.state.lines;

    for (TextBox box in boxes) {
      double boxCenterY = (box.top + box.bottom) / 2;
      LineMetrics? currentLine;

      for (LineMetrics line in lineMetrics) {
        double lineTop = line.baseline - line.ascent;
        double lineBottom = line.baseline + line.descent;

        if (boxCenterY >= lineTop && boxCenterY <= lineBottom) {
          currentLine = line;
          break;
        }
      }

      if (currentLine != null) {
        double lineTop = currentLine.baseline - currentLine.ascent;
        double lineBottom = currentLine.baseline + currentLine.descent;

        Rect rect = Rect.fromLTRB(box.left - 1, lineTop, box.right + 1, lineBottom);
        canvas.drawRect(rect, paint);
      } else {
        Rect rect = Rect.fromLTRB(box.left - 1, box.top, box.right + 1, box.bottom);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter oldDelegate) {
    return true;
  }
}

class _CursorPainter extends ChangeNotifier implements CustomPainter {
  _CursorPainter(this._controller) {
    _controller.addListener(_onTextEditingValueChanged);
    _onTextEditingValueChanged();
  }

  final SheetTextEditingController _controller;

  void _onTextEditingValueChanged() {
    startTimer();
    notifyListeners();
  }

  bool _cursorVisible = true;

  set cursorVisible(bool value) {
    _cursorVisible = value;
    notifyListeners();
  }

  Timer? timer;

  void startTimer() {
    stopTimer();
    cursorVisible = true;
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      cursorVisible = !_cursorVisible;
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  bool? hitTest(Offset position) {
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_cursorVisible) {
      return;
    }

    try {
      Rect? cursorRect = _cursorRect;

      if (cursorRect != null) {
        canvas.drawRect(cursorRect, Paint()..color = Colors.black);
      }
    } catch (e) {
      // ignore
    }
  }

  /// Returns the position of the cursor as an [Offset].
  Rect? get _cursorRect {
    SheetTextfieldState state = _controller.state;
    TextStyle previousStyle = _controller.previousStyle;

    late int currentLine;
    late double offsetX;
    late List<LineMetrics> lines;

    bool emptyText = _controller.value.span.toPlainText().isEmpty;
    if (emptyText) {
      TextPainter painter = _controller.buildTextPainter(TextSpan(text: 'I', style: previousStyle));

      currentLine = 0;
      offsetX = switch (_controller.textAlign) {
        TextAlign.left => 0,
        TextAlign.center => painter.width / 2,
        TextAlign.right => painter.width,
        (_) => 0,
      };

      lines = painter.computeLineMetrics();
    } else {
      TextSelection selection = _controller.value.selection;
      if (!selection.isCollapsed) {
        return null;
      }

      TextPainter painter = state.painter;
      Offset caretOffset = painter.getOffsetForCaret(TextPosition(offset: selection.end), Rect.zero);
      currentLine = state.getLineIndexForOffset(_controller.cursorAtEnd ? painter.height : caretOffset.dy);
      offsetX = caretOffset.dx;
      lines = state.lines;
    }

    double offsetY = 0;
    if (currentLine > 0) {
      List<double> lineHeights = lines.map((LineMetrics line) => line.height).toList().sublist(0, currentLine);
      offsetY = lineHeights.fold(0, (double a, double b) => a + b);
    }

    double? lineHeight = lines.elementAtOrNull(currentLine)?.height ?? 14;

    double fontSize = previousStyle.fontSize ?? 0;
    double cursorShift = (lineHeight - fontSize) / 2;

    return Rect.fromLTWH(offsetX, offsetY + cursorShift, 1, fontSize);
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRepaint(covariant _CursorPainter oldDelegate) {
    return oldDelegate._controller.value.selection != _controller.value.selection || _cursorVisible != oldDelegate._cursorVisible;
  }
}

class _LettersPainter extends ChangeNotifier implements CustomPainter {
  _LettersPainter(this._controller) {
    _controller.addListener(notifyListeners);
  }

  final SheetTextEditingController _controller;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, _controller.size.width, _controller.size.height));

    TextRangeStyleModifier selectionStyleModifier = TextRangeStyleModifier(
      start: _controller.selection.start,
      end: _controller.selection.end,
      modifier: (TextStyle style) {
        return style.copyWith(color: Colors.white);
      },
    );

    TextSpan textSpan = _controller.value.text.toTextSpan(styleModifier: selectionStyleModifier);

    TextPainter textPainter = _controller.buildTextPainter(textSpan);
    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant _LettersPainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) {
    return null;
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }
}
