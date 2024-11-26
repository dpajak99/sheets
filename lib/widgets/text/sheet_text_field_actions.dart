import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/utils/extensions/double_extensions.dart';
import 'package:sheets/utils/extensions/int_extensions.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/widgets/text/sheet_text_field.dart';

typedef TextStyleFormatter = TextStyle Function(TextStyle mergedStyle, TextStyle textStyle);

class SheetTextFieldActions {
  static SheetTextFieldAction moveCursor(Offset offset, {bool expandSelection = false}) {
    return _MoveCursorAction(offset, expandSelection: expandSelection);
  }

  static SheetTextFieldAction moveCursorByWord(int offset, {bool expandSelection = false}) {
    return _MoveCursorByWordAction(offset, expandSelection: expandSelection);
  }

  static SheetTextFieldAction insertText(String text) => _InsertTextAction(text);

  static SheetTextFieldAction removeText(int range) => _RemoveTextAction(range);

  static SheetTextFieldAction removeWord(int direction) => _RemoveWordAction(direction);

  static SheetTextFieldAction clear() => _ClearAction();

  static SheetTextFieldAction selectByOffset(Offset offset) => _SelectByOffsetAction(offset);

  static SheetTextFieldAction selectWordByOffset(Offset offset) => _SelectWordByOffsetAction(offset);

  static SheetTextFieldAction extendSelectionByOffset(Offset offset, {bool selectWords = false}) {
    return _ExtendSelectionByOffsetAction(offset, selectWords: selectWords);
  }

  static SheetTextFieldAction selectAll() => _SelectAllAction();

  static SheetTextFieldAction copy() => _CopyAction();

  static SheetTextFieldAction cut() => _CutAction();

  static SheetTextFieldAction paste() => _PasteAction();

  static SheetTextFieldAction format(TextStyleFormatIntent intent) => _FormatAction(intent);
}

abstract class SheetTextFieldAction {
  bool? _saveToHistory;

  FutureOr<SheetTextEditingValue> execute(SheetTextEditingController controller);

  void setShouldUpdateHistory(bool value) {
    _saveToHistory = value;
  }

  bool get shouldUpdateHistory {
    return _saveToHistory ?? false;
  }
}

class _MoveCursorAction extends SheetTextFieldAction {
  _MoveCursorAction(this.offset, {this.expandSelection = false});

  final Offset offset;
  final bool expandSelection;

  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    if (offset.dy != 0) {
      return _moveCursorVertically(controller);
    } else if (offset.dx != 0) {
      return _moveCursorHorizontally(controller);
    } else {
      return controller.value;
    }
  }

  SheetTextEditingValue _moveCursorHorizontally(SheetTextEditingController controller) {
    int newOffset = (controller.selection.extentOffset + offset.dx).safeClamp(0, controller.value.length).toInt();
    TextSelection newSelection = expandSelection
        ? controller.selection.copyWith(extentOffset: newOffset) //
        : TextSelection.collapsed(offset: newOffset);

    return controller.value.copyWith(selection: newSelection);
  }

  SheetTextEditingValue _moveCursorVertically(SheetTextEditingController controller) {
    TextPosition currentPosition = TextPosition(offset: controller.selection.extentOffset);
    Offset caretOffset = controller.state.painter.getOffsetForCaret(currentPosition, Rect.zero);

    int currentLine = controller.state.getLineIndexForOffset(caretOffset.dy);

    late TextPosition newPosition;
    if (currentLine == 0 && offset.dy < 0) {
      newPosition = const TextPosition(offset: 0);
    } else if (currentLine == controller.state.linesCount - 1 && offset.dy > 0) {
      newPosition = TextPosition(offset: controller.length);
    } else {
      int targetLine = (currentLine + offset.dy).safeClamp(0, controller.state.linesCount - 1).toInt();

      double dx = caretOffset.dx;
      double dy = controller.state.lines[targetLine].baseline;

      Offset targetOffset = Offset(dx, dy);
      newPosition = controller.state.painter.getPositionForOffset(targetOffset);
    }
    TextSelection newSelection = expandSelection
        ? controller.selection.copyWith(extentOffset: newPosition.offset) //
        : TextSelection.collapsed(offset: newPosition.offset);

    return controller.value.copyWith(selection: newSelection);
  }
}

class _MoveCursorByWordAction extends SheetTextFieldAction {
  _MoveCursorByWordAction(this.offset, {this.expandSelection = false});

  final int offset;
  final bool expandSelection;

  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    int currentOffset = expandSelection ? controller.selection.extentOffset : controller.selection.baseOffset;
    int newOffset = currentOffset;

    for (int i = 0; i < offset.abs(); i++) {
      if (offset > 0) {
        if (newOffset >= controller.value.text.rawText.length) {
          break;
        }
        newOffset = controller.state.getNextWordBoundary(newOffset);
      } else {
        if (newOffset <= 0) {
          break;
        }
        newOffset = controller.state.getPreviousWordBoundary(newOffset);
      }
    }

    TextSelection newSelection;
    if (expandSelection) {
      newSelection = controller.selection.copyWith(extentOffset: newOffset);
    } else {
      newSelection = TextSelection.collapsed(offset: newOffset);
    }

    return controller.value.copyWith(selection: newSelection);
  }
}

/// Inserts text at the current selection or cursor position.
class _InsertTextAction extends SheetTextFieldAction {
  _InsertTextAction(this.text);

  final String text;

  @override
  bool get shouldUpdateHistory => _containsWordDelimiter(text);

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    SheetTextEditingValue value = controller.value;

    if (controller.isAllSelected) {
      value = SheetTextEditingValue(
        text: value.text.clear(keepStyle: true),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    TextSelection selection = value.selection;
    int newOffset = selection.start + text.length;

    return controller.value.copyWith(
      text: value.text.insert(selection.start, text),
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class _RemoveTextAction extends SheetTextFieldAction {
  _RemoveTextAction(this.range);

  final int range;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    int removeStart;
    int removeEnd;

    if (controller.selection.isCollapsed) {
      removeStart = (controller.selection.start + range).safeClamp(0, controller.length);
      removeEnd = controller.selection.start;

      if (removeEnd == 0 && range < 0) {
        return controller.value;
      }
    } else {
      removeStart = controller.selection.start;
      removeEnd = controller.selection.end;
    }

    String deletedText = controller.value.text.rawText.substring(
      min(removeStart, removeEnd),
      max(removeStart, removeEnd),
    );

    if (_containsWordDelimiter(deletedText)) {
      setShouldUpdateHistory(true);
    }

    int newOffset = min(removeStart, removeEnd);
    return controller.value.copyWith(
      text: controller.value.text.removeRange(min(removeStart, removeEnd), max(removeStart, removeEnd)),
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

/// Removes a word based on the given direction.
/// If [direction] < 0, removes the word before the cursor.
/// If [direction] > 0, removes the word after the cursor.
class _RemoveWordAction extends SheetTextFieldAction {
  _RemoveWordAction(this.direction);

  final int direction;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    int removeStart;
    int removeEnd;

    if (controller.selection.isCollapsed) {
      if (direction < 0) {
        // Remove the word before the cursor.
        if (controller.cursorAtStart) {
          // Nothing to remove.
          return controller.value;
        }
        removeEnd = controller.selection.start;
        removeStart = controller.state.getPreviousWordBoundary(removeEnd);
        if (removeStart == removeEnd) {
          // No previous word found.
          return controller.value;
        }
      } else if (direction > 0) {
        // Remove the word after the cursor.
        if (controller.selection.start >= controller.length) {
          // Nothing to remove.
          return controller.value;
        }
        removeStart = controller.selection.start;
        removeEnd = controller.state.getNextWordBoundary(removeStart);
        if (removeStart == removeEnd) {
          // No next word found.
          return controller.value;
        }
      } else {
        // direction == 0, do nothing.
        return controller.value;
      }
    } else {
      // If there's a selection, remove the selected text.
      removeStart = controller.selection.start;
      removeEnd = controller.selection.end;
    }

    String deletedText = controller.value.text.rawText.substring(
      min(removeStart, removeEnd),
      max(removeStart, removeEnd),
    );

    if (_containsWordDelimiter(deletedText)) {
      setShouldUpdateHistory(true);
    }

    int newOffset = min(removeStart, removeEnd);
    return controller.value.copyWith(
      text: controller.value.text.removeRange(min(removeStart, removeEnd), max(removeStart, removeEnd)),
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class _ClearAction extends SheetTextFieldAction {
  @override
  bool get shouldUpdateHistory => true;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    return controller.value.copyWith(
      text: controller.value.text.clear(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }
}

/// Updates the selection to the position at the given [offset].
class _SelectByOffsetAction extends SheetTextFieldAction {
  _SelectByOffsetAction(this.offset);

  final Offset offset;

  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    TextPosition textPosition = controller.state.getPressedPosition(offset);
    return controller.value.copyWith(
      selection: TextSelection.collapsed(offset: textPosition.offset),
    );
  }
}

/// Selects the word at the given [offset].
class _SelectWordByOffsetAction extends SheetTextFieldAction {
  _SelectWordByOffsetAction(this.offset);

  final Offset offset;

  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    if (controller.cursorAtEnd) {
      return controller.value;
    }

    TextPosition textPosition = controller.state.getPressedPosition(offset);
    TextRange wordRange = controller.state.painter.getWordBoundary(textPosition);
    return controller.value.copyWith(
      selection: TextSelection(baseOffset: wordRange.start, extentOffset: wordRange.end),
    );
  }
}

/// Updates the selection by extending it to the given [offset].
/// If [selectWords] is true, selection will be extended by whole words.
class _ExtendSelectionByOffsetAction extends SheetTextFieldAction {
  _ExtendSelectionByOffsetAction(this.offset, {this.selectWords = false});

  final Offset offset;
  final bool selectWords;

  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    TextPosition textPosition = controller.state.getPressedPosition(offset);
    int baseOffset = controller.selection.baseOffset;
    int extentOffset;

    if (selectWords) {
      TextRange wordRange = controller.state.painter.getWordBoundary(textPosition);
      if (textPosition.offset >= baseOffset) {
        extentOffset = wordRange.end;
      } else {
        extentOffset = wordRange.start;
      }
    } else {
      extentOffset = textPosition.offset;
    }

    TextSelection newSelection = TextSelection(
      baseOffset: baseOffset,
      extentOffset: extentOffset,
    );
    return controller.value.copyWith(selection: newSelection);
  }
}

/// Selects all text.
class _SelectAllAction extends SheetTextFieldAction {
  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    int textLength = controller.value.length;
    return controller.value.copyWith(
      selection: TextSelection(baseOffset: 0, extentOffset: textLength),
    );
  }
}

/// Copies the selected text to the clipboard.
class _CopyAction extends SheetTextFieldAction {
  @override
  bool get shouldUpdateHistory => false;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    TextSelection selection = controller.value.selection;
    if (selection.isCollapsed) {
      return controller.value;
    }

    String selectedText = controller.value.text.rawText.substring(selection.start, selection.end);
    unawaited(Clipboard.setData(ClipboardData(text: selectedText)));
    return controller.value;
  }
}

/// Cuts the selected text and copies it to the clipboard.
class _CutAction extends SheetTextFieldAction {
  @override
  bool get shouldUpdateHistory => true;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    TextSelection selection = controller.value.selection;
    if (selection.isCollapsed) {
      return controller.value;
    }

    String selectedText = controller.value.text.rawText.substring(selection.start, selection.end);
    unawaited(Clipboard.setData(ClipboardData(text: selectedText)));

    return controller.value.copyWith(
      text: controller.value.text.removeRange(selection.start, selection.end),
      selection: TextSelection.collapsed(offset: selection.start),
    );
  }
}

/// Pastes text from the clipboard at the current cursor position.
class _PasteAction extends SheetTextFieldAction {
  @override
  bool get shouldUpdateHistory => true;

  @override
  Future<SheetTextEditingValue> execute(SheetTextEditingController controller) async {
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null || clipboardData.text == null || clipboardData.text!.isEmpty) {
      return controller.value;
    }

    String textToPaste = clipboardData.text!;

    TextSelection selection = controller.value.selection;
    EditableTextSpan text = controller.value.text;
    if (!selection.isCollapsed) {
      text = controller.value.text.removeRange(selection.start, selection.end);
    }

    int newOffset = selection.start + textToPaste.length;
    return controller.value.copyWith(
      text: text.insert(selection.start, textToPaste),
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

/// Formats the selected text using the provided formatter function.
class _FormatAction extends SheetTextFieldAction {
  _FormatAction(this.intent);

  final TextStyleFormatIntent intent;

  @override
  bool get shouldUpdateHistory => true;

  @override
  SheetTextEditingValue execute(SheetTextEditingController controller) {
    TextSelection selection = controller.value.selection;
    EditableTextSpan textSpan = controller.value.text.format(
      start: selection.start,
      end: selection.end,
      intent: intent,
    );

    return controller.value.copyWith(text: textSpan);
  }
}

bool _containsWordDelimiter(String text) {
  RegExp wordDelimiterRegExp = RegExp(r'\s|[.,;:!?]');
  return wordDelimiterRegExp.hasMatch(text);
}
