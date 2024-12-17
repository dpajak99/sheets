import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/menu/goog_palette.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_button.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_border_style_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_color_border_btn.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

typedef BorderChangedCallback = void Function(BorderEdges edges, Color color, double width);

class GoogToolbarBorderBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarBorderBtn({
    required this.onChanged,
    super.key,
  });

  final BorderChangedCallback onChanged;

  @override
  Size get size => const Size(32, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<BorderChangedCallback>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _GoogToolbarBorderBtnState();
}

class _GoogToolbarBorderBtnState extends State<GoogToolbarBorderBtn> {
  final DropdownButtonController _dropdownController = DropdownButtonController();
  final DropdownButtonController _colorDropdownController = DropdownButtonController();
  late Color _selectedColor = Colors.black;
  late int _selectedWidth = 1;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogToolbarButton(
          padding: const EdgeInsets.only(top: 9, bottom: 7),
          width: widget.size.width,
          height: widget.size.height,
          margin: widget.margin,
          child: const GoogIcon(SheetIcons.docs_icon_border_all_20),
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogPalette(
          gap: 2,
          columns: 5,
          trailing: Column(
            children: <Widget>[
              GoogToolbarColorBorderBtn(
                controller: _colorDropdownController,
                value: _selectedColor,
                onChanged: (Color color) {
                  _colorDropdownController.close();
                  setState(() => _selectedColor = color);
                },
              ),
              const SizedBox(height: 2),
              GoogToolbarBorderStyleBtn(
                value: _selectedWidth,
                onChanged: (int width) {
                  setState(() => _selectedWidth = width);
                },
              )
            ],
          ),
          children: BorderEdges.values.map((BorderEdges edge) {
            return _BorderOption(
              value: edge,
              onPressed: (BorderEdges border) {
                widget.onChanged(border, _selectedColor, _selectedWidth.toDouble());
                _dropdownController.close();
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _BorderOption extends StatelessWidget {
  const _BorderOption({
    required BorderEdges value,
    required ValueChanged<BorderEdges> onPressed,
  })  : _value = value,
        _onPressed = onPressed;

  final BorderEdges _value;
  final ValueChanged<BorderEdges> _onPressed;

  @override
  Widget build(BuildContext context) {
    AssetIconData icon = switch (_value) {
      BorderEdges.all => SheetIcons.docs_icon_border_all_20,
      BorderEdges.inner => SheetIcons.docs_icon_border_inside_20,
      BorderEdges.horizontal => SheetIcons.docs_icon_border_horizontal_20,
      BorderEdges.vertical => SheetIcons.docs_icon_border_vertical_20,
      BorderEdges.outer => SheetIcons.docs_icon_border_outside_20,
      BorderEdges.left => SheetIcons.docs_icon_border_left_20,
      BorderEdges.top => SheetIcons.docs_icon_border_top_20,
      BorderEdges.right => SheetIcons.docs_icon_border_right_20,
      BorderEdges.bottom => SheetIcons.docs_icon_border_bottom_20,
      BorderEdges.clear => SheetIcons.docs_icon_border_none_20,
    };

    return GoogPaletteItem(
      size: 32,
      icon: icon,
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      onPressed: () => _onPressed(_value),
    );
  }
}
