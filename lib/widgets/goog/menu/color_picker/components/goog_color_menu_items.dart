import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/widgets/goog/menu/color_picker/components/color_hex_textfield_picker.dart';
import 'package:sheets/widgets/goog/menu/color_picker/components/color_palette_picker.dart';
import 'package:sheets/widgets/goog/menu/color_picker/components/color_rgb_textfield_picker.dart';
import 'package:sheets/widgets/goog/menu/color_picker/components/color_slider_picker.dart';
import 'package:sheets/widgets/material/generic/material_elevated_button.dart';
import 'package:sheets/widgets/material/generic/material_icon_rect_button.dart';
import 'package:sheets/widgets/material/generic/material_outlined_button.dart';

class GoogColorMenuItems extends StatefulWidget {
  const GoogColorMenuItems({
    this.selectedColor = const Color(0xFFFF0000),
    this.onChanged,
    super.key,
  });

  final Color selectedColor;
  final ValueChanged<Color>? onChanged;

  @override
  State<StatefulWidget> createState() => _GoogColorMenuItemsState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ObjectFlagProperty<ValueChanged<Color>?>.has('onChanged', onChanged));
  }
}

class _GoogColorMenuItemsState extends State<GoogColorMenuItems> {
  static final List<Color> _valueColors = <Color>[Colors.transparent, Colors.black];
  static final List<Color> _hueColors = <Color>[
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0)
  ];

  late HSVColor _color = HSVColor.fromColor(widget.selectedColor);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 347,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 149,
              child: ColorPalettePicker(
                color: _color.toColor(),
                borderRadius: BorderRadius.circular(3),
                position: Offset(_color.saturation, _color.value),
                onChanged: _handleSaturationChange,
                leftRightColors: _saturationColors,
                topPosition: 1,
                bottomPosition: 0,
                topBottomColors: _valueColors,
              ),
            ),
            const SizedBox(height: 29),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: Color(0xffE8EAED), shape: BoxShape.circle),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: _color.toColor(), shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ),
                MaterialIconRectButton(
                  icon: Icons.colorize_outlined,
                  onPressed: () {},
                ),
                ColorSliderPicker(
                  max: 360,
                  width: 183,
                  height: 10,
                  value: _color.hue,
                  onChanged: _handleHueChange,
                  colors: _hueColors,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TextColorSection(
              color: _color.toColor(),
              onColorChanged: _handleColorChange,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SheetOutlinedButton(
                  label: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 16),
                MaterialElevatedButton(
                  label: 'OK',
                  onPressed: () {
                    Navigator.of(context).pop(_color.toColor());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleColorChange(HSVColor value) {
    _color = value;
    widget.onChanged?.call(value.toColor());
    setState(() {});
  }

  void _handleHueChange(double value) {
    _color = _color.withHue(value);
    widget.onChanged?.call(_color.toColor());
    setState(() {});
  }

  void _handleSaturationChange(Offset value) {
    _handleColorChange(HSVColor.fromAHSV(_color.alpha, _color.hue, value.dx, value.dy));
  }

  List<Color> get _saturationColors {
    return <Color>[
      Colors.white,
      HSVColor.fromAHSV(1, _color.hue, 1, 1).toColor(),
    ];
  }
}

class _TextColorSection extends StatelessWidget {
  const _TextColorSection({
    required Color color,
    required ValueChanged<HSVColor> onColorChanged,
  })  : _color = color,
        _onColorChanged = onColorChanged;

  final Color _color;
  final ValueChanged<HSVColor> _onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ColorHEXTextfieldPicker(
          color: _color,
          onChanged: (Color color) {
            _onColorChanged(HSVColor.fromColor(color));
          },
        ),
        const SizedBox(width: 8),
        ColorRGBTextfieldPicker(
          color: _color,
          onChanged: (Color color) {
            _onColorChanged(HSVColor.fromColor(color));
          },
        ),
      ],
    );
  }
}
