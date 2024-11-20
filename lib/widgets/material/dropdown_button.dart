import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef DropdownButtonBuilder = Widget Function(BuildContext context, bool isOpen);

typedef DropdownPopupBuilder = Widget Function(BuildContext context);

class DropdownButtonController {
  void Function()? _open;
  void Function()? _close;
  void Function()? _toggle;
  bool Function()? _isOpen;

  /// Opens the popup if it's not already open.
  void open() {
    _open?.call();
  }

  /// Closes the popup if it's open.
  void close() {
    _close?.call();
  }

  /// Toggles the popup's visibility.
  void toggle() {
    _toggle?.call();
  }

  /// Returns `true` if the popup is open, `false` otherwise.
  bool get isOpen {
    return _isOpen?.call() ?? false;
  }
}

class SheetDropdownButton extends StatefulWidget {
  const SheetDropdownButton({
    required this.buttonBuilder,
    required this.popupBuilder,
    this.level = 1,
    this.controller,
    super.key,
  });

  final DropdownButtonBuilder buttonBuilder;
  final DropdownPopupBuilder popupBuilder;
  final int level;
  final DropdownButtonController? controller;

  @override
  State<StatefulWidget> createState() => _SheetDropdownButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<DropdownButtonBuilder>.has('buttonBuilder', buttonBuilder));
    properties.add(ObjectFlagProperty<DropdownPopupBuilder>.has('popupBuilder', popupBuilder));
    properties.add(IntProperty('level', level));
    properties.add(DiagnosticsProperty<DropdownButtonController?>('controller', controller));
  }
}

class _SheetDropdownButtonState extends State<SheetDropdownButton> {
  // Map to keep track of open popups at each level
  static final Map<int, _SheetDropdownButtonState> _currentlyOpenPopups = <int, _SheetDropdownButtonState>{};

  OverlayEntry? _overlayEntry;
  final GlobalKey _popupKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Link controller methods
    widget.controller?._open = _showPopup;
    widget.controller?._close = _hidePopup;
    widget.controller?._toggle = _togglePopup;
    widget.controller?._isOpen = () => _overlayEntry != null;
  }

  @override
  void didUpdateWidget(SheetDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller references if the controller instance changed
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._open = null;
      oldWidget.controller?._close = null;
      oldWidget.controller?._toggle = null;
      oldWidget.controller?._isOpen = null;

      widget.controller?._open = _showPopup;
      widget.controller?._close = _hidePopup;
      widget.controller?._toggle = _togglePopup;
      widget.controller?._isOpen = () => _overlayEntry != null;
    }
  }

  void _togglePopup() {
    if (_overlayEntry == null) {
      _showPopup();
    } else {
      _hidePopup();
    }
  }

  void _showPopup() {
    if (_overlayEntry != null) {
      return;
    }

    // Close popups at the same or higher levels
    _closePopupsAtOrAboveLevel(widget.level);

    // Create and insert new popup
    OverlayEntry newOverlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(newOverlayEntry);

    _overlayEntry = newOverlayEntry;
    _currentlyOpenPopups[widget.level] = this;
    if(mounted) {
      setState(() {});
    }
  }

  void _hidePopup() {
    if (_overlayEntry == null) {
      return;
    }

    _overlayEntry?.remove();
    _overlayEntry = null;

    // Remove from the map of open popups
    if (_currentlyOpenPopups[widget.level] == this) {
      _currentlyOpenPopups.remove(widget.level);
    }
    if(mounted) {
      setState(() {});
    }
  }

  // Close popups at the same or higher levels
  void _closePopupsAtOrAboveLevel(int level) {
    List<int> levelsToClose = _currentlyOpenPopups.keys.where((int l) => l >= level).toList();
    for (int l in levelsToClose) {
      if (_currentlyOpenPopups[l] != null && _currentlyOpenPopups[l] != this) {
        _currentlyOpenPopups[l]!._hidePopup();
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          // Listener to detect taps outside the popup
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (PointerDownEvent event) {
              // Check if the tap was inside any open popups or buttons at or above the current level
              if (!_isTapInsideOpenPopupsOrButtons(event.position)) {
                _hidePopup();
              }
            },
            child: Container(), // Empty container to cover the screen
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + renderBox.size.height,
            child: Container(
              key: _popupKey,
              child: widget.popupBuilder(context),
            ),
          ),
        ],
      );
    });
  }

  bool _isTapInsideOpenPopupsOrButtons(Offset tapPosition) {
    // Check if tap is inside this popup or button
    if (_isTapInsideWidget(tapPosition, _popupKey) || _isTapInsideWidget(tapPosition, _buttonKey)) {
      return true;
    }

    // Check if tap is inside any open popups or buttons at higher levels
    for (int level in _currentlyOpenPopups.keys) {
      if (level > widget.level) {
        _SheetDropdownButtonState? popupState = _currentlyOpenPopups[level];
        if (popupState != null) {
          if (popupState._isTapInsideWidget(tapPosition, popupState._popupKey) ||
              popupState._isTapInsideWidget(tapPosition, popupState._buttonKey)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _isTapInsideWidget(Offset tapPosition, GlobalKey key) {
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      Offset offset = renderBox.localToGlobal(Offset.zero);
      Size size = renderBox.size;

      if (tapPosition.dx >= offset.dx &&
          tapPosition.dx <= offset.dx + size.width &&
          tapPosition.dy >= offset.dy &&
          tapPosition.dy <= offset.dy + size.height) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      behavior: HitTestBehavior.translucent,
      onTap: _togglePopup,
      child: widget.buttonBuilder(context, _overlayEntry != null),
    );
  }

  @override
  void dispose() {
    _hidePopup();
    // Clean up controller references
    widget.controller?._open = null;
    widget.controller?._close = null;
    widget.controller?._toggle = null;
    widget.controller?._isOpen = null;
    super.dispose();
  }
}
