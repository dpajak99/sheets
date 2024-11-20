import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_color_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_options_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_popup.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';
import 'package:sheets/widgets/popup_button.dart';

class MaterialRotationButton extends StatefulWidget with MaterialToolbarItemMixin {
  const MaterialRotationButton({
    required this.onChanged,
    required this.selectedRotation,
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
  final TextRotation selectedRotation;
  final ValueChanged<TextRotation> onChanged;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<TextRotation>>.has('onChanged', onChanged));
    properties.add(DiagnosticsProperty<TextRotation?>('selectedRotation', selectedRotation));
  }

  @override
  State<StatefulWidget> createState() => _MaterialRotationButtonState();
}

class _MaterialRotationButtonState extends State<MaterialRotationButton> {
  @override
  Widget build(BuildContext context) {
    AssetIconData icon = switch (widget.selectedRotation) {
      TextRotation.none => SheetIcons.text_rotation_none,
      TextRotation.angleUp => SheetIcons.text_rotation_angleup,
      TextRotation.angleDown => SheetIcons.text_rotation_angledown,
      TextRotation.vertical => SheetIcons.text_rotation_vertical,
      TextRotation.up => SheetIcons.text_rotation_up,
      TextRotation.down => SheetIcons.text_rotation_down,
      (_) => SheetIcons.right_angle,
    };
    
    return PopupButton(
      button: MaterialToolbarIconButton.withDropdown(
        icon: icon,
        onTap: () {},
      ),
      popupBuilder: (BuildContext context) {
        return _OptionsPopup(
          onSelected: widget.onChanged,
          selectedRotation: widget.selectedRotation,
          options: const <IconOptionValue<TextRotation>>[
            IconOptionValue<TextRotation>(value: TextRotation.none, icon: SheetIcons.text_rotation_none),
            IconOptionValue<TextRotation>(value: TextRotation.angleUp, icon: SheetIcons.text_rotation_angleup),
            IconOptionValue<TextRotation>(value: TextRotation.angleDown, icon: SheetIcons.text_rotation_angledown),
            IconOptionValue<TextRotation>(value: TextRotation.vertical, icon: SheetIcons.text_rotation_vertical),
            IconOptionValue<TextRotation>(value: TextRotation.up, icon: SheetIcons.text_rotation_up),
            IconOptionValue<TextRotation>(value: TextRotation.down, icon: SheetIcons.text_rotation_down),
          ],
        );
      },
    );
  }
}

class _OptionsPopup extends StatefulWidget {
  const _OptionsPopup({
    required this.options,
    required this.onSelected,
    required this.selectedRotation,
    this.columnsCount = 6,
    this.color = Colors.black,
    super.key,
  });

  final List<IconOptionValue<TextRotation>> options;
  final ValueChanged<TextRotation> onSelected;
  final int columnsCount;
  final TextRotation selectedRotation;
  final Color color;

  @override
  State<StatefulWidget> createState() => _OptionsPopupState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('columnsCount', columnsCount));
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<TextRotation>>.has('onSelected', onSelected));
    properties.add(IterableProperty<IconOptionValue<TextRotation>>('options', options));
    properties.add(DiagnosticsProperty<TextRotation>('selectedRotation', selectedRotation));
  }
}

class _OptionsPopupState extends State<_OptionsPopup> {
  late TextRotation _selectedRotation = widget.selectedRotation;

  @override
  Widget build(BuildContext context) {
    int columnsCount = widget.columnsCount;
    int rowsCount = (widget.options.length / columnsCount).ceil();
    print('rowsCount: $rowsCount');

    return Material(
      borderRadius: BorderRadius.circular(3),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 4, top: 11, bottom: 11),
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

                          IconOptionValue<TextRotation> option = widget.options[index];
                          return _OptionsPopupButton<TextRotation>(
                            active: option.value == _selectedRotation,
                            icon: option.icon,
                            onTap: () {
                              setState(() {
                                _selectedRotation = option.value;
                              });
                              widget.onSelected(option.value);
                            },
                          );
                        }),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 32,
              child: VerticalDivider(color: Color(0xffeeeeee), width: 1, thickness: 1),
            ),
            const SizedBox(width: 8),
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