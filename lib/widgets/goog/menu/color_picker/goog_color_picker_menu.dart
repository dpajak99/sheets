import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/color_utils.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/color_picker/components/goog_color_menu_items.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogColorPickerMenu extends StatelessWidget {
  const GoogColorPickerMenu({
    required Color defaultColor,
    required Color selectedColor,
    required ValueChanged<Color> onChanged,
    super.key,
  })  : _defaultColor = defaultColor,
        _selectedColor = selectedColor,
        _onChanged = onChanged;

  final Color _defaultColor;
  final Color _selectedColor;
  final ValueChanged<Color> _onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GoogMenuItem(
          leading: const GoogIcon(SheetIcons.docs_icon_no_color),
          label: const GoogText('Resetuj'),
          onPressed: () => _onChanged(_defaultColor),
        ),
        const SizedBox(height: 2),
        _ColorGrid(
          columns: 10,
          selectedColor: _selectedColor,
          onChanged: _onChanged,
          colors: MaterialSheetTheme.baseColors,
        ),
        const SizedBox(height: 2),
        const GoogMenuSectionHeader(
          label: GoogText('STANDARDOWY'),
          icon: SheetIcons.docs_icon_line_color,
          padding: EdgeInsets.only(bottom: 4, left: 6, right: 6),
        ),
        const SizedBox(height: 2),
        _ColorGrid(
          columns: 10,
          selectedColor: MaterialSheetTheme.baseColors.contains(ColorUtils.colorToInt(_selectedColor)) ? null : _selectedColor,
          onChanged: _onChanged,
          colors: MaterialSheetTheme.standardColors,
        ),
        const GoogMenuSeperator(padding: EdgeInsets.symmetric(vertical: 6)),
        const GoogMenuSectionHeader(
          label: GoogText('NIESTANDARDOWE'),
          padding: EdgeInsets.only(bottom: 4, left: 6, right: 6),
        ),
        const SizedBox(height: 2),
        _CustomColorSection(
          selectedColor: MaterialSheetTheme.baseColors.contains(ColorUtils.colorToInt(_selectedColor)) ? null : _selectedColor,
          onChanged: _onChanged,
        ),
      ],
    );
  }
}

class _CustomColorSection extends StatefulWidget {
  const _CustomColorSection({
    required this.onChanged,
    this.selectedColor,
  });

  final ValueChanged<Color> onChanged;
  final Color? selectedColor;

  @override
  State<StatefulWidget> createState() => _CustomColorSectionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
    properties.add(ColorProperty('selectedColor', selectedColor));
  }
}

class _CustomColorSectionState extends State<_CustomColorSection> {
  final List<Color> _customColors = <Color>[];

  @override
  Widget build(BuildContext context) {
    return _ColorGrid(
      columns: 10,
      selectedColor: widget.selectedColor,
      onChanged: widget.onChanged,
      colors: _customColors.map(ColorUtils.colorToInt).toList(),
      customWidgets: <Widget>[
        GoogMenuIconButton(
          padding: const EdgeInsets.only(bottom: 3, right: 3, top: 2, left: 2),
          icon: SheetIcons.docs_icon_add_item,
          onPressed: _requestCustomColor,
        ),
        GoogMenuIconButton(
          icon: SheetIcons.docs_icon_colorize,
          onPressed: () {
            // TODO(dominik): Missing implementation
          },
        ),
      ],
    );
  }

  Future<void> _requestCustomColor() async {
    Color? color = await showDialog(
      context: context,
      builder: (BuildContext context) => const GoogColorMenuItems(),
    );
    _addCustomColor(color);
  }

  void _addCustomColor(Color? color) {
    if (color != null) {
      setState(() => _customColors.add(color));
      widget.onChanged(color);
    }
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({
    required int columns,
    required List<int> colors,
    required ValueChanged<Color> onChanged,
    List<Widget>? customWidgets,
    Color? selectedColor,
  })  : _columns = columns,
        _colors = colors,
        _onChanged = onChanged,
        _customWidgets = customWidgets ?? const <Widget>[],
        _selectedColor = selectedColor;

  final int _columns;
  final List<int> _colors;
  final ValueChanged<Color> _onChanged;
  final List<Widget> _customWidgets;
  final Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> colorWidgets = _colors.map((int color) {
      return _ColorGridItem(
        selected: _selectedColor != null && ColorUtils.colorToInt(_selectedColor) == color,
        color: Color(color),
        onPressed: _onChanged,
      );
    }).toList();

    List<Widget> visibleWidgets = <Widget>[
      ...colorWidgets,
      ..._customWidgets,
    ];

    int rows = (visibleWidgets.length / _columns).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < rows; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int j = 0; j < _columns; j++)
                if (visibleWidgets.elementAtOrNull(i * _columns + j) != null) visibleWidgets[i * _columns + j],
            ],
          ),
      ],
    );
  }
}

class _ColorGridItem extends StatelessWidget {
  const _ColorGridItem({
    required bool selected,
    required Color color,
    required ValueChanged<Color> onPressed,
  })  : _selected = selected,
        _color = color,
        _onPressed = onPressed;

  final bool _selected;
  final Color _color;
  final ValueChanged<Color> _onPressed;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = _color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return WidgetStateBuilder(
      onTap: () => _onPressed(_color),
      builder: (Set<WidgetState> states) {
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
            boxShadow: states.contains(WidgetState.hovered)
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 2,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignCenter,
              color: const Color(0xFFECEDEF),
            ),
          ),
          child: _selected
              ? Center(
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: foregroundColor,
                  ),
                )
              : null,
        );
      },
    );
  }
}
