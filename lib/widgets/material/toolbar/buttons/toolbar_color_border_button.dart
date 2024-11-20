import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/widgets/material/components/colors_grid_picker.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_color_picker_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarColorBorderButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarColorBorderButton({
    required Color value,
    required ValueChanged<Color> onChanged,
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _value = value,
        _onChanged = onChanged,
        _size = size ?? const Size(37, 26),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1);

  static final Color _defaultColor = defaultTextStyle.color ?? Colors.black;

  final Size _size;
  final EdgeInsets _margin;
  final Color _value;
  final ValueChanged<Color> _onChanged;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarColorPickerButton(
          size: size,
          margin: margin,
          opened: isOpen,
          selectedColor: _value,
          icon: SheetIcons.border_color,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 244,
          padding: const EdgeInsets.all(11),
          children: <Widget>[
            ColorsGridPicker(
              defaultColor: _defaultColor,
              selectedColor: _value,
              onChanged: _onChanged,
            ),
          ],
        );
      },
    );
  }
}
