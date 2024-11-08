import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/material_palette_color_picker.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialColorPicker extends StatefulWidget {
  const MaterialColorPicker({
    required this.onColorChanged,
    required this.selectedColor,
    super.key,
  });

  final void Function(Color) onColorChanged;
  final Color selectedColor;

  @override
  State<MaterialColorPicker> createState() => _MaterialColorPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function(Color p1)>.has('onColorChanged', onColorChanged));
    properties.add(ColorProperty('selectedColor', selectedColor));
  }
}

class _MaterialColorPickerState extends State<MaterialColorPicker> {
  static const List<int> baseColors = <int>[
    0xFF000000, 0xFF434343, 0xFF666666, 0xFF999999, 0xFFB7B7B7, 0xFFCCCCCC, 0xFFD9D9D9, 0xFFEFEFEF, 0xFFF3F3F3, 0xFFFFFFFF, //
    0xFF980000, 0xFFFF0000, 0xFFFF9900, 0xFFFFFF00, 0xFF00FF00, 0xFF00FFFF, 0xFF4A86E8, 0xFF0000FF, 0xFF9900FF, 0xFFFF00FF, //
    0xFFE6B8AF, 0xFFF4CCCC, 0xFFFCE5CD, 0xFFFFF2CC, 0xFFD9EAD3, 0xFFD0E0E3, 0xFFC9DAF8, 0xFFCFE2F3, 0xFFD9D2E9, 0xFFEAD1DC, //
    0xFFDD7E6B, 0xFFEA9999, 0xFFF9CB9C, 0xFFFFE599, 0xFFB6D7A8, 0xFFA2C4C9, 0xFFA4C2F4, 0xFF9FC5E8, 0xFFB4A7D6, 0xFFD5A6BD, //
    0xFFCC4125, 0xFFE06666, 0xFFF6B26B, 0xFFFFD966, 0xFF93C47D, 0xFF76A5AF, 0xFF6D9EEB, 0xFF6FA8DC, 0xFF8E7CC3, 0xFFC27BA0, //
    0xFFA61C00, 0xFFCC0000, 0xFFE69138, 0xFFF1C232, 0xFF6AA84F, 0xFF45818E, 0xFF3C78D8, 0xFF3D85C6, 0xFF674EA7, 0xFFA64D79, //
    0xFF85200C, 0xFF990000, 0xFFB45F06, 0xFFBF9000, 0xFF38761D, 0xFF134F5C, 0xFF1155CC, 0xFF0B5394, 0xFF351C75, 0xFF741B47, //
    0xFF5B0F00, 0xFF660000, 0xFF783F04, 0xFF7F6000, 0xFF274E13, 0xFF0C343D, 0xFF1C4587, 0xFF073763, 0xFF20124D, 0xFF4C1130, //
  ];

  static const List<int> standardColors = <int>[
    0xFF000000, 0xFFFFFFFF, 0xFF4285F4, 0xFFEA4335, 0xFFFBBC04, 0xFF34A853, 0xFFFF6D01, 0xFF46BDC6 //
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: 244,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ColorPickerButton(
              icon: Icons.format_color_reset,
              label: 'Reset',
              onPressed: () => _changeColor(Color(baseColors.first)),
            ),
            const SizedBox(height: 2),
            ColorsGrid(
              columns: 10,
              selectedColor: _selectedColor,
              onColorChanged: _changeColor,
              colors: baseColors,
            ),
            const SizedBox(height: 2),
            const ColorPickerLabel(label: 'STANDARD', icon: Icons.edit),
            const SizedBox(height: 2),
            ColorsGrid(
              columns: 10,
              selectedColor: baseColors.contains(_selectedColor.value) ? null : _selectedColor,
              onColorChanged: _changeColor,
              colors: standardColors,
            ),
            const SizedBox(height: 2),
            const ColorPickerDivider(),
            const SizedBox(height: 2),
            const ColorPickerLabel(label: 'CUSTOM'),
            const SizedBox(height: 2),
            ColorPickerCustomSection(
              selectedColor: baseColors.contains(_selectedColor.value) ? null : _selectedColor,
              onChanged: _changeColor,
            ),
          ],
        ),
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
    widget.onColorChanged(color);
  }
}

class ColorPickerCustomSection extends StatefulWidget {
  final ValueChanged<Color> onChanged;
  final Color? selectedColor;

  const ColorPickerCustomSection({
    required this.onChanged,
    this.selectedColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ColorPickerCustomSectionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
    properties.add(ColorProperty('selectedColor', selectedColor));
  }
}

class _ColorPickerCustomSectionState extends State<ColorPickerCustomSection> {
  final List<Color> _customColors = <Color>[];

  @override
  Widget build(BuildContext context) {
    return ColorsGrid(
        columns: 10,
        selectedColor: widget.selectedColor,
        onColorChanged: widget.onChanged,
        colors: _customColors.map((Color color) => color.value).toList(),
        customWidgets: <Widget>[
          ColorPickerLabelIconButton(
            icon: Icons.add_circle_outline,
            onPressed: () async {
              Color? color = await showDialog(
                context: context,
                builder: (BuildContext context) => const MaterialPaletteColorPickerDialog(),
              );
              if (color != null) {
                setState(() => _customColors.add(color));
                widget.onChanged(color);
              }
            },
          ),
          ColorPickerLabelIconButton(icon: Icons.colorize, onPressed: () {}),
        ]);
  }
}

class ColorsGrid extends StatelessWidget {
  final int columns;
  final List<int> colors;
  final ValueChanged<Color> onColorChanged;
  final List<Widget> customWidgets;
  final Color? selectedColor;

  const ColorsGrid({
    required this.columns,
    required this.colors,
    required this.onColorChanged,
    this.customWidgets = const <Widget>[],
    this.selectedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> colorWidgets = colors.map((int color) {
      return ColorGridItem(
        selected: selectedColor?.value == color,
        color: Color(color),
        onColorChanged: onColorChanged,
      );
    }).toList();

    List<Widget> visibleWidgets = <Widget>[
      ...colorWidgets,
      ...customWidgets,
    ];

    int rows = (visibleWidgets.length / columns).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < rows; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (int j = 0; j < columns; j++)
                if (visibleWidgets.elementAtOrNull(i * columns + j) != null) visibleWidgets[i * columns + j],
            ],
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('columns', columns));
    properties.add(IterableProperty<int>('colors', colors));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onColorChanged', onColorChanged));
    properties.add(ColorProperty('selectedColor', selectedColor));
  }
}

class ColorGridItem extends StatelessWidget {
  final bool selected;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorGridItem({
    required this.selected,
    required this.color,
    required this.onColorChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return MouseStateListener(
      onTap: () => onColorChanged(color),
      childBuilder: (Set<WidgetState> states) {
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: color,
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
          child: selected
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onColorChanged', onColorChanged));
  }
}

class ColorPickerLabel extends StatelessWidget {
  final String label;
  final IconData? icon;

  const ColorPickerLabel({
    required this.label,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff444746),
              fontSize: 11,
              height: 1.1,
              fontWeight: FontWeight.w600,
              fontFamily: 'GoogleSans',
              package: 'sheets',
            ),
          ),
          if (icon != null) ...<Widget>[
            ColorPickerLabelIconButton.small(icon: icon!, onPressed: () {}),
          ],
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
  }
}

class ColorPickerDivider extends StatelessWidget {
  const ColorPickerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 1,
          width: double.infinity,
          color: const Color(0xffDADCE0),
        ),
      ),
    );
  }
}

class ColorPickerLabelIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const ColorPickerLabelIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  }) : size = 18;

  const ColorPickerLabelIconButton.small({
    required this.icon,
    required this.onPressed,
    super.key,
  }) : size = 16;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onPressed,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          height: 21,
          width: 21,
          decoration: BoxDecoration(
            color: states.contains(WidgetState.hovered) ? const Color(0xfff1f3f4) : Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            icon,
            size: size,
            color: const Color(0xff444746),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(DoubleProperty('size', size));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class ColorPickerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const ColorPickerButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff444746);

    return MouseStateListener(
      onTap: onPressed,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          width: double.infinity,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: states.contains(WidgetState.hovered) ? const Color(0xffF1F3F4) : Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 17,
                height: 17,
                child: icon != null ? Icon(icon, size: 17, color: foregroundColor) : null,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 15,
                  height: 1.1,
                  fontFamily: 'GoogleSans',
                  package: 'sheets',
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
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
  }
}
