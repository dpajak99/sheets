import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_color_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_options_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_popup.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialBorderButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialBorderButton({
    required this.onChanged,
    this.width = 39,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final BorderSelectedCallback onChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<BorderSelectedCallback>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _MaterialBorderButtonState();
}

class _MaterialBorderButtonState extends State<MaterialBorderButton> {
  @override
  Widget build(BuildContext context) {
    return PopupButton(
      button: MaterialToolbarIconButton.withDropdown(
        icon: SheetIcons.border_all,
        onTap: () {},
      ),
      popupBuilder: (BuildContext context) {
        return _OptionsPopup(
          onSelected: widget.onChanged,
          options: const <IconOptionValue<BorderEdges>>[
            IconOptionValue<BorderEdges>(value: BorderEdges.all, icon: SheetIcons.border_all),
            IconOptionValue<BorderEdges>(value: BorderEdges.inner, icon: SheetIcons.border_inner),
            IconOptionValue<BorderEdges>(value: BorderEdges.horizontal, icon: SheetIcons.border_horizontal),
            IconOptionValue<BorderEdges>(value: BorderEdges.vertical, icon: SheetIcons.border_vertical),
            IconOptionValue<BorderEdges>(value: BorderEdges.outer, icon: SheetIcons.border_outer),
            IconOptionValue<BorderEdges>(value: BorderEdges.left, icon: SheetIcons.border_left),
            IconOptionValue<BorderEdges>(value: BorderEdges.top, icon: SheetIcons.border_top),
            IconOptionValue<BorderEdges>(value: BorderEdges.right, icon: SheetIcons.border_right),
            IconOptionValue<BorderEdges>(value: BorderEdges.bottom, icon: SheetIcons.border_bottom),
            IconOptionValue<BorderEdges>(value: BorderEdges.clear, icon: SheetIcons.border_clear),
          ],
        );
      },
    );
  }
}

typedef BorderSelectedCallback = void Function(BorderEdges edges, Color color, double width);

enum BorderEdges { all, inner, horizontal, vertical, outer, left, top, right, bottom, clear }

class _OptionsPopup extends StatefulWidget {
  const _OptionsPopup({
    required this.options,
    required this.onSelected,
    this.columnsCount = 5,
    this.color = Colors.black,
    super.key,
  });

  final List<IconOptionValue<BorderEdges>> options;
  final BorderSelectedCallback onSelected;
  final int columnsCount;
  final Color color;

  @override
  State<StatefulWidget> createState() => _OptionsPopupState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<IconOptionValue<BorderEdges>>('options', options));
    properties.add(IntProperty('columnsCount', columnsCount));
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<BorderSelectedCallback>.has('onSelected', onSelected));
  }
}

class _OptionsPopupState extends State<_OptionsPopup> {
  late Color _selectedColor = widget.color;
  int _selectedWidth = 1;

  @override
  Widget build(BuildContext context) {
    int columnsCount = widget.columnsCount;
    int rowsCount = (widget.options.length / columnsCount).ceil();

    return Material(
      borderRadius: BorderRadius.circular(3),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 4, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xffF1F4F9),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                for (int y = 0; y < rowsCount; y++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int x = 0; x < columnsCount; x++)
                        Builder(builder: (BuildContext context) {
                          int index = y * columnsCount + x;
                          if (index >= widget.options.length) {
                            return const SizedBox(width: 28, height: 28);
                          }

                          IconOptionValue<BorderEdges> option = widget.options[index];
                          return _OptionsPopupButton<BorderEdges>(
                            icon: option.icon,
                            onTap: () {
                              widget.onSelected(option.value, _selectedColor, _selectedWidth.toDouble());
                            },
                          );
                        }),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 64,
              child: VerticalDivider(color: Color(0xffeeeeee), width: 1, thickness: 1),
            ),
            const SizedBox(width: 8),
            Column(
              children: <Widget>[
                MaterialToolbarColorButton(
                  level: 2,
                  color: _selectedColor,
                  onSelected: (Color color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  icon: SheetIcons.border_color,
                  button: _ColorPickerButton(
                    width: 37,
                    height: 26,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    selectedColor: _selectedColor,
                    icon: SheetIcons.border_color,
                  ),
                ),
                const SizedBox(height: 2),
                _BorderWidthPopupButton(
                  selectedValue: _selectedWidth,
                  onSelected: (int value) {
                    _selectedWidth = value;
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _OptionsPopupButton<T> extends StatelessWidget with MaterialToolbarButtonMixin {
  const _OptionsPopupButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.width = 32,
    this.height = 32,
    super.key,
  });

  @override
  final bool active;
  final double width;
  final double height;
  final AssetIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Color? backgroundColor = getBackgroundColor(states);
        Color? foregroundColor = getForegroundColor(states);

        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: AssetIcon(icon, size: 19, color: foregroundColor),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _ColorPickerButton extends StatelessWidget with MaterialToolbarButtonMixin {
  const _ColorPickerButton({
    required this.width,
    required this.height,
    required this.margin,
    required this.selectedColor,
    required this.icon,
    this.pressed = false,
  });

  final bool pressed;
  final double width;
  final double height;
  final EdgeInsets margin;
  final Color selectedColor;
  final AssetIconData icon;

  @override
  bool get active => false;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
      childBuilder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = getBackgroundColor(updatedStates);
        Color? foregroundColor = getForegroundColor(updatedStates);

        return Container(
          width: width,
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 25,
                height: 26,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Center(
                      child: AssetIcon(icon, size: 19, color: foregroundColor),
                    ),
                    Positioned(
                      top: 19,
                      left: 2,
                      right: 2,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(color: selectedColor),
                      ),
                    ),
                  ],
                ),
              ),
              AssetIcon(
                SheetIcons.dropdown,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(DiagnosticsProperty<bool>('pressed', pressed));
  }
}

class _BorderWidthPopupButton extends StatefulWidget with MaterialToolbarItemMixin {
  const _BorderWidthPopupButton({
    required this.onSelected,
    required this.selectedValue,
    this.width = 37,
    this.height = 26,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final ValueChanged<int> onSelected;
  final int selectedValue;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<int>>.has('onSelected', onSelected));
    properties.add(IntProperty('selectedValue', selectedValue));
  }

  @override
  State<StatefulWidget> createState() => _BorderWidthPopupButtonState();
}

class _BorderWidthPopupButtonState extends State<_BorderWidthPopupButton> {
  final PopupController _popupController = PopupController();
  late int _selectedValue = widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    return PopupButton(
      controller: _popupController,
      level: 2,
      button: const _BorderWidthButton(
        width: 39,
        height: 30,
        margin: EdgeInsets.symmetric(horizontal: 1),
        icon: SheetIcons.line_style,
      ),
      popupBuilder: (BuildContext context) {
        return MaterialToolbarPopup(
          width: 122,
          child: Column(
            children: <Widget>[
              _SelectableButton(
                selected: _selectedValue == 1,
                onTap: () => _onSelected(1),
                child: Container(width: double.infinity, height: 1, color: Colors.black),
              ),
              _SelectableButton(
                selected: _selectedValue == 2,
                onTap: () => _onSelected(2),
                child: Container(width: double.infinity, height: 2, color: Colors.black),
              ),
              _SelectableButton(
                selected: _selectedValue == 3,
                onTap: () => _onSelected(3),
                child: Container(width: double.infinity, height: 3, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSelected(int value) {
    _popupController.close();
    setState(() {
      _selectedValue = value;
    });
    widget.onSelected(value);
  }
}

class _SelectableButton extends StatelessWidget {
  const _SelectableButton({
    required this.onTap,
    required this.child,
    this.selected = false,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: <Widget>[
              if (selected) const Icon(Icons.check, size: 16, color: Color(0xff444746)) else const SizedBox(width: 16),
              const SizedBox(width: 10),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffe8eaed);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF1F3F4);
    } else {
      return Colors.white;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _BorderWidthButton extends StatelessWidget with MaterialToolbarButtonMixin {
  const _BorderWidthButton({
    required this.width,
    required this.height,
    required this.margin,
    required this.icon,
    this.pressed = false,
  });

  final bool pressed;
  final double width;
  final double height;
  final EdgeInsets margin;
  final AssetIconData icon;

  @override
  bool get active => false;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
      childBuilder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = getBackgroundColor(updatedStates);
        Color? foregroundColor = getForegroundColor(updatedStates);

        return Container(
          width: width,
          height: height,
          margin: margin,
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
                  child: AssetIcon(icon, size: 19, color: foregroundColor),
                ),
              ),
              AssetIcon(
                SheetIcons.dropdown,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(DiagnosticsProperty<bool>('pressed', pressed));
  }
}
