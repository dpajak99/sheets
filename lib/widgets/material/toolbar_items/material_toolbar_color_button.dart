import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/material_color_picker.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialToolbarColorButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialToolbarColorButton({
    required this.color,
    required this.onSelected,
    required this.icon,
    this.width = 32,
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
  final Color color;
  final ValueChanged<Color> onSelected;
  final AssetIconData icon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onSelected', onSelected));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
  }

  @override
  State<StatefulWidget> createState() => _MaterialToolbarColorButtonState();
}

class _MaterialToolbarColorButtonState extends State<MaterialToolbarColorButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return PopupButton(
      button: _ColorPickerButton(
        pressed: _pressed,
        selectedColor: widget.color,
        icon: widget.icon,
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
      ),
      onToggle: (bool isPressed) {
        setState(() {
          _pressed = isPressed;
        });
      },
      popupBuilder: (BuildContext context) {
        return MaterialColorPicker(
          selectedColor: widget.color,
          onColorChanged: widget.onSelected,
        );
      },
    );
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
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: AssetIcon(icon, size: 19, color: foregroundColor),
              ),
              Positioned(
                top: 20,
                left: 4.5,
                right: 4.5,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(color: selectedColor),
                ),
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
