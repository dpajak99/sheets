import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/menu/color_picker/goog_color_picker_menu.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_color_indicator.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarColorFontBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarColorFontBtn({
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
  State<StatefulWidget> createState() => _GoogToolbarColorFontBtnState();
}

class _GoogToolbarColorFontBtnState extends State<GoogToolbarColorFontBtn> {
  static final Color _defaultColor = defaultTextStyle.color ?? Colors.black;

  final DropdownButtonController _dropdownController = DropdownButtonController();

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogColorIndicator(
          color: widget.value,
          child: GoogToolbarButton(
            // opened: isOpen,
            width: widget.size.width,
            height: widget.size.height,
            padding: const EdgeInsets.only(bottom: 4),
            child: const GoogIcon(SheetIcons.docs_icon_text_color_20),
          ),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
          width: 244,
          padding: const EdgeInsets.all(11),
          children: <Widget>[
            GoogColorPickerMenu(
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
    widget.onChanged(color);
  }
}
