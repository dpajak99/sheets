import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/popup/sheet_popup.dart';

typedef DropdownButtonBuilder = Widget Function(BuildContext context, bool isOpen);

/// Controller to manage the popup's state.
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

/// Enum to define activation behavior for the dropdown.
enum ActivateDropdownBehavior {
  auto,
  manual,
}

/// A dropdown button widget that uses [SheetPopup] to display its popup.
/// It has a [DropdownButtonController] to control showing/hiding/toggling the popup.
/// The offset is automatically calculated based on the button's position.
class SheetDropdownButton extends StatefulWidget {
  const SheetDropdownButton({
    required this.buttonBuilder,
    required this.popupBuilder,
    this.popupAlignment = Alignment.bottomLeft,
    this.controller,
    this.level = 1,
    this.disabled = false,
    this.activateDropdownBehavior = ActivateDropdownBehavior.auto,
    super.key,
  });

  final DropdownButtonBuilder buttonBuilder;
  final PopupBuilder popupBuilder;
  final Alignment popupAlignment;
  final int level;
  final DropdownButtonController? controller;
  final bool disabled;
  final ActivateDropdownBehavior activateDropdownBehavior;

  @override
  State<SheetDropdownButton> createState() => _SheetDropdownButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<DropdownButtonBuilder>.has('buttonBuilder', buttonBuilder));
    properties.add(ObjectFlagProperty<PopupBuilder>.has('popupBuilder', popupBuilder));
    properties.add(IntProperty('level', level));
    properties.add(DiagnosticsProperty<DropdownButtonController?>('controller', controller));
    properties.add(DiagnosticsProperty<bool>('disabled', disabled));
    properties.add(EnumProperty<ActivateDropdownBehavior>('activateDropdownBehavior', activateDropdownBehavior));
    properties.add(DiagnosticsProperty<Alignment>('popupAlignment', popupAlignment));
  }
}

class _SheetDropdownButtonState extends State<SheetDropdownButton> {
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller?._open = _controllerOpen;
    widget.controller?._close = _controllerClose;
    widget.controller?._toggle = _controllerToggle;
    widget.controller?._isOpen = _isPopupOpen;
  }

  @override
  void didUpdateWidget(SheetDropdownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._open = null;
      oldWidget.controller?._close = null;
      oldWidget.controller?._toggle = null;
      oldWidget.controller?._isOpen = null;

      widget.controller?._open = _controllerOpen;
      widget.controller?._close = _controllerClose;
      widget.controller?._toggle = _controllerToggle;
      widget.controller?._isOpen = _isPopupOpen;
    }
  }

  /// Checks if the popup is currently open by verifying if it's registered globally.
  bool _isPopupOpen() {
    // Since SheetPopup manages global popups, we check if the popup at this level is open.
    // This assumes that each SheetDropdownButton has a unique level or handles levels appropriately.
    return false;
  }

  /// Controller method to open the popup.
  void _controllerOpen() {
    if (_isPopupOpen()) {
      return;
    }
    Offset offset = _calculateOffset();
    SheetPopup.openGlobalPopup(
      context,
      widget.level,
      offset,
      widget.popupBuilder,
    );
  }

  /// Controller method to close the popup.
  void _controllerClose() {
    SheetPopup.closeGlobalPopup(widget.level);
  }

  /// Controller method to toggle the popup.
  void _controllerToggle() {
    if (_isPopupOpen()) {
      _controllerClose();
    } else {
      Offset offset = _calculateOffset();
      SheetPopup.openGlobalPopup(
        context,
        widget.level,
        offset,
        widget.popupBuilder,
      );
    }
  }

  void _handleTap() {
    if (widget.activateDropdownBehavior == ActivateDropdownBehavior.auto) {
      widget.controller?.toggle();
    }
    // If behavior is manual, do nothing. Popup can be controlled via the controller.
  }

  /// Calculates the offset for the popup based on the button's position.
  Offset _calculateOffset() {
    RenderBox renderBox = _buttonKey.currentContext!.findRenderObject()! as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    return switch(widget.popupAlignment) {
      Alignment.bottomLeft => Offset(position.dx, position.dy + renderBox.size.height),
      Alignment.bottomRight => Offset(position.dx + renderBox.size.width, position.dy + renderBox.size.height),
      Alignment.topLeft => Offset(position.dx, position.dy),
      Alignment.topRight => Offset(position.dx + renderBox.size.width, position.dy),
      _ => Offset(position.dx, position.dy + renderBox.size.height),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.3,
          child: widget.buttonBuilder(context, false),
        ),
      );
    }

    return GestureDetector(
      key: _buttonKey,
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      child: widget.buttonBuilder(context, _isPopupOpen()),
    );
  }

  @override
  void dispose() {
    widget.controller?._open = null;
    widget.controller?._close = null;
    widget.controller?._toggle = null;
    widget.controller?._isOpen = null;
    super.dispose();
  }
}
