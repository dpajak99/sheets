import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {
  const PopupButton({
    required this.button,
    required this.popupBuilder,
    this.onToggle,
    super.key,
  });

  final Widget button;
  final WidgetBuilder popupBuilder;
  final ValueChanged<bool>? onToggle;

  @override
  State<StatefulWidget> createState() => _PopupButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('popupBuilder', popupBuilder));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onToggle', onToggle));
  }
}

class _PopupButtonState extends State<PopupButton> {
  static _PopupButtonState? _currentlyOpenPopup;

  OverlayEntry? _overlayEntry;
  final GlobalKey _popupKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  void _showPopup() {
    if (_overlayEntry != null) {
      return;
    }

    OverlayEntry newOverlayEntry = _createOverlayEntry();

    Overlay.of(context).insert(newOverlayEntry);
    widget.onToggle?.call(true);

    if (_currentlyOpenPopup != null && _currentlyOpenPopup != this) {
      _currentlyOpenPopup!._hidePopup();
    }

    _overlayEntry = newOverlayEntry;
    _currentlyOpenPopup = this;
  }

  void _hidePopup() {
    widget.onToggle?.call(false);
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (_currentlyOpenPopup == this) {
      _currentlyOpenPopup = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (PointerDownEvent event) {
              RenderBox? popupRenderBox = _popupKey.currentContext?.findRenderObject() as RenderBox?;
              bool isInPopup = false;
              if (popupRenderBox != null) {
                Offset popupOffset = popupRenderBox.localToGlobal(Offset.zero);
                Size popupSize = popupRenderBox.size;

                if (event.position.dx >= popupOffset.dx &&
                    event.position.dx <= popupOffset.dx + popupSize.width &&
                    event.position.dy >= popupOffset.dy &&
                    event.position.dy <= popupOffset.dy + popupSize.height) {
                  isInPopup = true;
                }
              }

              RenderBox? buttonRenderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
              bool isInButton = false;
              if (buttonRenderBox != null) {
                Offset buttonOffset = buttonRenderBox.localToGlobal(Offset.zero);
                Size buttonSize = buttonRenderBox.size;

                if (event.position.dx >= buttonOffset.dx &&
                    event.position.dx <= buttonOffset.dx + buttonSize.width &&
                    event.position.dy >= buttonOffset.dy &&
                    event.position.dy <= buttonOffset.dy + buttonSize.height) {
                  isInButton = true;
                }
              }

              if (!isInPopup && !isInButton) {
                _hidePopup();
              }
            },
            child: Container(),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_overlayEntry == null) {
          _showPopup();
        } else {
          _hidePopup();
        }
      },
      child: widget.button,
    );
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }
}
