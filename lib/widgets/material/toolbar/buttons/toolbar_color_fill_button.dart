import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/color_picker/color_grid_picker.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_color_picker_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarColorFillButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarColorFillButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Color value;
  final ValueChanged<Color> onChanged;

  @override
  Size get size => const Size(32, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarColorFillButtonState();
}

class _ToolbarColorFillButtonState extends State<ToolbarColorFillButton> {
  final DropdownButtonController _dropdownController = DropdownButtonController();
  static const Color _defaultColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarColorPickerButton(
          size: widget.size,
          margin: widget.margin,
          opened: isOpen,
          selectedColor: widget.value,
          icon: SheetIcons.format_color_fill,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 244,
          padding: const EdgeInsets.all(11),
          children: <Widget>[
            ColorGridPicker(
              defaultColor: _defaultColor,
              selectedColor: widget.value,
              onChanged: _handleColorChanged,
            ),
          ],
        );
      },
    );
  }

  void _handleColorChanged(Color color) {
    _dropdownController.close();
    if (color == _defaultColor || color == Colors.transparent) {
      widget.onChanged(_defaultColor);
    } else {
      widget.onChanged(color);
    }
  }
}
