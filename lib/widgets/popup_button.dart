import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {

  const PopupButton({
    required this.button,
    required this.popupBuilder,
    super.key,
  });

  final Widget button;
  final WidgetBuilder popupBuilder;

  @override
  State<StatefulWidget> createState() => _PopupButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<WidgetBuilder>.has('popupBuilder', popupBuilder));
  }
}

class _PopupButtonState extends State<PopupButton> {
  OverlayEntry? _overlayEntry;

  void _showPopup() {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (BuildContext context) => Positioned(
        left: offset.dx,
        top: offset.dy + renderBox.size.height,
        child: widget.popupBuilder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
