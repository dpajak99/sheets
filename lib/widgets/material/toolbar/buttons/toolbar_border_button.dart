import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_grid_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_border_style_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_color_border_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

typedef BorderChangedCallback = void Function(BorderEdges edges, Color color, double width);

class ToolbarBorderButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarBorderButton({
    required this.onChanged,
    super.key,
  });

  final BorderChangedCallback onChanged;

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<BorderChangedCallback>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarBorderButtonState();
}

class _ToolbarBorderButtonState extends State<ToolbarBorderButton> {
  late Color _selectedColor = Colors.black;
  late int _selectedWidth = 1;

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarIconButton.withDropdown(
          icon: SheetIcons.border_all,
          size: widget.size,
          margin: widget.margin,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownGridMenu(
          gap: 2,
          columns: 5,
          trailing: Column(
            children: <Widget>[
              ToolbarColorBorderButton(
                value: _selectedColor,
                onChanged: (Color color) {
                  setState(() => _selectedColor = color);
                },
              ),
              const SizedBox(height: 2),
              ToolbarBorderStyleButton(
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
      BorderEdges.all => SheetIcons.border_all,
      BorderEdges.inner => SheetIcons.border_inner,
      BorderEdges.horizontal => SheetIcons.border_horizontal,
      BorderEdges.vertical => SheetIcons.border_vertical,
      BorderEdges.outer => SheetIcons.border_outer,
      BorderEdges.left => SheetIcons.border_left,
      BorderEdges.top => SheetIcons.border_top,
      BorderEdges.right => SheetIcons.border_right,
      BorderEdges.bottom => SheetIcons.border_bottom,
      BorderEdges.clear => SheetIcons.border_clear,
    };

    return DropdownGridMenuItem(selected: false, icon: icon, onPressed: () => _onPressed(_value));
  }
}
