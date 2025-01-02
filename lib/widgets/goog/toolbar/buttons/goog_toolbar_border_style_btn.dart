import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogToolbarBorderStyleBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarBorderStyleBtn({
    required this.onChanged,
    required this.value,
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _size = size ?? const Size(37, 26),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1);

  final Size _size;
  final EdgeInsets _margin;
  final ValueChanged<int> onChanged;
  final int value;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<int>>.has('onSelected', onChanged));
    properties.add(IntProperty('selectedValue', value));
  }

  @override
  State<StatefulWidget> createState() => _GoogToolbarBorderStyleBtnState();
}

class _GoogToolbarBorderStyleBtnState extends State<GoogToolbarBorderStyleBtn> {
  final DropdownButtonController _dropdownButtonController = DropdownButtonController();
  late int _selectedValue = widget.value;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownButtonController,
      level: 2,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogToolbarMenuButton(
          width: widget.size.width,
          height: widget.size.height,
          margin: widget.margin,
          childPadding: const EdgeInsets.only(top: 8, bottom: 6),
          child: const GoogIcon(SheetIcons.docs_icon_line_style_20),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
          width: 122,
          children: <Widget>[
            _BorderStyleOption(
              selected: _selectedValue == 1,
              onTap: () => _onSelected(1),
              child: Container(width: double.infinity, height: 1, color: Colors.black),
            ),
            _BorderStyleOption(
              selected: _selectedValue == 2,
              onTap: () => _onSelected(2),
              child: Container(width: double.infinity, height: 2, color: Colors.black),
            ),
            _BorderStyleOption(
              selected: _selectedValue == 3,
              onTap: () => _onSelected(3),
              child: Container(width: double.infinity, height: 3, color: Colors.black),
            ),
          ],
        );
      },
    );
  }

  void _onSelected(int value) {
    _dropdownButtonController.close();
    setState(() {
      _selectedValue = value;
    });
    widget.onChanged(value);
  }
}

class _BorderStyleOption extends StatelessWidget {
  const _BorderStyleOption({
    required Widget child,
    required VoidCallback onTap,
    required bool selected,
  })  : _child = child,
        _onTap = onTap,
        _selected = selected;

  final Widget _child;
  final VoidCallback _onTap;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onTap,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _resolveBackgroundColor(states);
        Color? foregroundColor = _resolveForegroundColor(states);

        return Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: <Widget>[
              if (_selected) Icon(Icons.check, size: 16, color: foregroundColor) else const SizedBox(width: 16),
              const SizedBox(width: 10),
              Expanded(child: _child),
            ],
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xFFE8EAED);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xFFF1F3F4);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}
