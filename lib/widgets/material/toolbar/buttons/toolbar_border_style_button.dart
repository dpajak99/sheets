import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarBorderStyleButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarBorderStyleButton({
    required this.onChanged,
    required this.value,
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _size = size ?? const Size(39, 30),
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
  State<StatefulWidget> createState() => _ToolbarBorderStyleButtonState();
}

class _ToolbarBorderStyleButtonState extends State<ToolbarBorderStyleButton> {
  final DropdownButtonController _dropdownButtonController = DropdownButtonController();
  late int _selectedValue = widget.value;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownButtonController,
      level: 2,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return _BorderStyleButton(
          size: widget.size,
          margin: widget.margin,
          icon: SheetIcons.docs_icon_line_style_20,
          opened: isOpen,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
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

class _BorderStyleButton extends StatelessWidget {
  const _BorderStyleButton({
    required Size size,
    required EdgeInsets margin,
    required AssetIconData icon,
    required bool opened,
  })  : _size = size,
        _margin = margin,
        _icon = icon,
        _opened = opened;

  final Size _size;
  final EdgeInsets _margin;
  final AssetIconData _icon;
  final bool _opened;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (_opened) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = _resolveBackgroundColor(updatedStates);
        Color? foregroundColor = _resolveForegroundColor(updatedStates);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 25,
                height: 26,
                child: Center(
                  child: AssetIcon(_icon, size: 19, color: foregroundColor),
                ),
              ),
              AssetIcon(
                SheetIcons.docs_icon_arrow_dropdown,
                width: 8,
                height: 4,
                color: foregroundColor,
              ),
            ],
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}
