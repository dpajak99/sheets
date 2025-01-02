import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/menu/color_picker/goog_color_picker_menu.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_color_indicator.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarColorBorderBtn extends StatelessWidget implements StaticSizeWidget {
  const GoogToolbarColorBorderBtn({
    required Color value,
    required ValueChanged<Color> onChanged,
    Size? size,
    EdgeInsets? margin,
    DropdownButtonController? controller,
    super.key,
  })  : _value = value,
        _onChanged = onChanged,
        _size = size ?? const Size(37, 26),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _controller = controller;

  static final Color _defaultColor = defaultTextStyle.color ?? Colors.black;

  final Size _size;
  final EdgeInsets _margin;
  final Color _value;
  final ValueChanged<Color> _onChanged;
  final DropdownButtonController? _controller;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      level: 2,
      controller: _controller,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogColorIndicator(
          color: _value,
          lbPosition: const Offset(2, 1),
          width: 21,
          child: GoogToolbarMenuButton(
            width: size.width,
            height: size.height,
            margin: margin,
            childPadding: const EdgeInsets.only(top: 4, bottom: 9),
            child: const GoogIcon(SheetIcons.docs_icon_border_color_20),
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
              selectedColor: _value,
              onChanged: _onChanged,
            ),
          ],
        );
      },
    );
  }
}
