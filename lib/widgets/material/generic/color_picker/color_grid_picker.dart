import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/dialogs/color_palette_dialog.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ColorGridPicker extends StatelessWidget {
  const ColorGridPicker({
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
        DropdownListMenuItem(
          icon: SheetIcons.format_color_reset,
          label: 'Resetuj',
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
        const DropdownListMenuSubtitle(
          label: 'STANDARDOWY',
          icon: SheetIcons.edit,
          padding: EdgeInsets.only(bottom: 4, left: 6, right: 6),
        ),
        const SizedBox(height: 2),
        _ColorGrid(
          columns: 10,
          selectedColor: MaterialSheetTheme.baseColors.contains(_selectedColor.value) ? null : _selectedColor,
          onChanged: _onChanged,
          colors: MaterialSheetTheme.standardColors,
        ),
        const DropdownListMenuDivider(padding: EdgeInsets.symmetric(vertical: 6)),
        const DropdownListMenuSubtitle(
          label: 'NIESTANDARDOWE',
          padding: EdgeInsets.only(bottom: 4, left: 6, right: 6),
        ),
        const SizedBox(height: 2),
        _CustomColorSection(
          selectedColor: MaterialSheetTheme.baseColors.contains(_selectedColor.value) ? null : _selectedColor,
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
      colors: _customColors.map((Color color) => color.value).toList(),
      customWidgets: <Widget>[
        _ColorGridIconButton(
          icon: SheetIcons.add_circle,
          onPressed: _requestCustomColor,
        ),
        _ColorGridIconButton(
          icon: SheetIcons.colorize,
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
      builder: (BuildContext context) => const ColorPaletteDialog(),
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
    super.key,
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
        selected: _selectedColor?.value == color,
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

class _ColorGridIconButton extends StatelessWidget {
  const _ColorGridIconButton({
    required AssetIconData icon,
    required VoidCallback onPressed,
    double? size,
  })  : _icon = icon,
        _onPressed = onPressed,
        _size = size ?? 19;

  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _resolveBackgroundColor(states);
        Color? foregroundColor = _resolveForegroundColor(states);

        return Container(
          height: _size,
          width: _size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: AssetIcon(_icon, size: _size, color: foregroundColor),
        );
      },
    );
  }

  Color? _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF1F3F4);
    } else {
      return null;
    }
  }

  Color? _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xff444746);
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
