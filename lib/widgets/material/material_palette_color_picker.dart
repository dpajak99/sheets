import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/widgets/material/palette_picker.dart';
import 'package:sheets/widgets/material/slider_picker.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialPaletteColorPickerDialog extends StatefulWidget {
  const MaterialPaletteColorPickerDialog({
    this.selectedColor = const Color(0xFFFF0000),
    this.onChanged,
    super.key,
  });

  final Color selectedColor;
  final ValueChanged<Color>? onChanged;

  @override
  State<MaterialPaletteColorPickerDialog> createState() => _MaterialPaletteColorPickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('selectedColor', selectedColor));
    properties.add(ObjectFlagProperty<ValueChanged<Color>?>.has('onChanged', onChanged));
  }
}

class _MaterialPaletteColorPickerDialogState extends State<MaterialPaletteColorPickerDialog> {
  late HSVColor color = HSVColor.fromColor(widget.selectedColor);

  // Hue
  void colorOnChange(HSVColor value) {
    color = value;
    widget.onChanged?.call(value.toColor());
    setState(() {});
  }

  void hueOnChange(double value) {
    color = color.withHue(value);
    widget.onChanged?.call(color.toColor());
    setState(() {});
  }

  List<Color> get hueColors {
    return <Color>[
      const Color.fromARGB(255, 255, 0, 0),
      const Color.fromARGB(255, 255, 255, 0),
      const Color.fromARGB(255, 0, 255, 0),
      const Color.fromARGB(255, 0, 255, 255),
      const Color.fromARGB(255, 0, 0, 255),
      const Color.fromARGB(255, 255, 0, 255),
      const Color.fromARGB(255, 255, 0, 0)
    ];
  }

  // Saturation Value
  void saturationValueOnChange(Offset value) {
    colorOnChange(HSVColor.fromAHSV(color.alpha, color.hue, value.dx, value.dy));
  }

  // Saturation
  List<Color> get saturationColors {
    return <Color>[
      Colors.white,
      HSVColor.fromAHSV(1, color.hue, 1, 1).toColor(),
    ];
  }

  // Value
  final List<Color> valueColors = <Color>[
    Colors.transparent,
    Colors.black,
  ];

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
              child: PalettePicker(
                color: color.toColor(),
                borderRadius: BorderRadius.circular(3),
                position: Offset(color.saturation, color.value),
                onChanged: saturationValueOnChange,
                leftRightColors: saturationColors,
                topPosition: 1,
                bottomPosition: 0,
                topBottomColors: valueColors,
              ),
            ),
            const SizedBox(height: 29),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(color: Color(0xffE8EAED), shape: BoxShape.circle),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: color.toColor(), shape: BoxShape.circle),
                      ),
                    ],
                  ),
                ),
                SheetIconButton(
                  icon: Icons.colorize_outlined,
                  onPressed: () {},
                ),
                SliderPicker(
                  max: 360,
                  width: 183,
                  height: 10,
                  value: color.hue,
                  onChanged: hueOnChange,
                  colors: hueColors,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextColorSection(
              color: color.toColor(),
              onColorChanged: colorOnChange,
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
                SheetElevatedButton(
                  label: 'OK',
                  onPressed: () {
                    Navigator.of(context).pop(color.toColor());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HSVColor>('color', color));
    properties.add(IterableProperty<Color>('hueColors', hueColors));
    properties.add(IterableProperty<Color>('saturationColors', saturationColors));
    properties.add(IterableProperty<Color>('valueColors', valueColors));
  }
}

class TextColorSection extends StatelessWidget {

  const TextColorSection({
    required this.color,
    required this.onColorChanged,
    super.key,
  });
  final Color color;
  final ValueChanged<HSVColor> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RGBHexTextValuePicker(
          color: color,
          onChanged: (Color color) {
            onColorChanged(HSVColor.fromColor(color));
          },
        ),
        const SizedBox(width: 8),
        RGBTextValuePicker(
          color: color,
          onChanged: (Color color) {
            onColorChanged(HSVColor.fromColor(color));
          },
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<HSVColor>>.has('onColorChanged', onColorChanged));
  }
}

class RGBHexTextValuePicker extends StatefulWidget {

  const RGBHexTextValuePicker({
    required this.color,
    required this.onChanged,
    super.key,
  });
  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<StatefulWidget> createState() => _RGBHexTextValuePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
  }
}

class _RGBHexTextValuePickerState extends State<RGBHexTextValuePicker> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = '#${widget.color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';

    focusNode.addListener(() {
      if(!focusNode.hasFocus) {
        controller.text = '#${widget.color.value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PickerTextField(
      focusNode: focusNode,
      areaWidth: 95,
      textFieldWidth: 75,
      label: 'Hex',
      controller: controller,
      formatters: [RGBAHexInputFormatter()],
      onChanged: (String value) {
        String parsedValue = value.startsWith('#') ? value.substring(1) : value;
        print('Parsed value: (${parsedValue.length}) $parsedValue');
        if (parsedValue.length == 8) {
          print('Updating color from hex: $parsedValue');
          widget.onChanged(Color(int.parse(parsedValue, radix: 16)));
        }
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
  }
}

class RGBTextValuePicker extends StatefulWidget {

  const RGBTextValuePicker({
    required this.color,
    required this.onChanged,
    super.key,
  });
  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<StatefulWidget> createState() => _RGBTextValuePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
  }
}

class _RGBTextValuePickerState extends State<RGBTextValuePicker> {
  final FocusNode redFocusNode = FocusNode();
  final FocusNode greenFocusNode = FocusNode();
  final FocusNode blueFocusNode = FocusNode();

  final TextEditingController redController = TextEditingController();
  final TextEditingController greenController = TextEditingController();
  final TextEditingController blueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    redController.text = widget.color.red.toString();
    greenController.text = widget.color.green.toString();
    blueController.text = widget.color.blue.toString();

    redFocusNode.addListener(() {
      if(!redFocusNode.hasFocus) {
        int? red = widget.color.red;
        redController.text = red.toString();
      }
    });

    greenFocusNode.addListener(() {
      if(!greenFocusNode.hasFocus) {
        int? green = widget.color.green;
        greenController.text = green.toString();
      }
    });

    blueFocusNode.addListener(() {
      if(!blueFocusNode.hasFocus) {
        int? blue = widget.color.blue;
        blueController.text = blue.toString();
      }
    });
  }

  @override
  void dispose() {
    redFocusNode.dispose();
    greenFocusNode.dispose();
    blueFocusNode.dispose();

    redController.dispose();
    greenController.dispose();
    blueController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RGBTextValuePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.color != oldWidget.color) {
      if(redFocusNode.hasFocus || greenFocusNode.hasFocus || blueFocusNode.hasFocus) {
        return;
      }
      redController.text = widget.color.red.toString();
      greenController.text = widget.color.green.toString();
      blueController.text = widget.color.blue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PickerTextField(
          focusNode: redFocusNode,
          controller: redController,
          areaWidth: 43,
          label: 'R',
          formatters: [RGBInputFormatter()],
          onChanged: (String value) {
            int? red = value.isEmpty ? 0 : int.tryParse(value);
            _onColorChanged(red: red);
          },
        ),
        const SizedBox(width: 8),
        _PickerTextField(
          focusNode: greenFocusNode,
          controller: greenController,
          areaWidth: 43,
          label: 'G',
          formatters: [RGBInputFormatter()],
          onChanged: (String value) {
            int? green = value.isEmpty ? 0 : int.tryParse(value);
            _onColorChanged(green: green);
          },
        ),
        const SizedBox(width: 8),
        _PickerTextField(
          focusNode: blueFocusNode,
          controller: blueController,
          areaWidth: 43,
          label: 'B',
          formatters: [RGBInputFormatter()],
          onChanged: (String value) {
            int? blue = value.isEmpty ? 0 : int.tryParse(value);
            _onColorChanged(blue: blue);
          },
        ),
      ],
    );
  }

  void _onColorChanged({int? red, int? green, int? blue}) {
    widget.onChanged(Color.fromARGB(
      255,
      (red != null && red >= 0 && red <= 255) ? red : widget.color.red,
      (green != null && green >= 0 && green <= 255) ? green: widget.color.green,
      (blue != null && blue >= 0 && blue <= 255) ? blue : widget.color.blue,
    ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FocusNode>('redFocusNode', redFocusNode));
    properties.add(DiagnosticsProperty<FocusNode>('greenFocusNode', greenFocusNode));
    properties.add(DiagnosticsProperty<FocusNode>('blueFocusNode', blueFocusNode));
    properties.add(DiagnosticsProperty<TextEditingController>('redController', redController));
    properties.add(DiagnosticsProperty<TextEditingController>('greenController', greenController));
    properties.add(DiagnosticsProperty<TextEditingController>('blueController', blueController));
  }
}

class SheetOutlinedButton extends StatelessWidget {

  const SheetOutlinedButton({
    required this.label,
    required this.onPressed,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onPressed,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            border: Border.all(color: _getStrokeColor(states)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff3C7D3E),
            ),
          ),
        );
      },
    );
  }

  Color _getStrokeColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffC8E7D1);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffC8E7D1);
    } else {
      return const Color(0xffB5E0C1);
    }
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDFF2E4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF8FCF9);
    } else {
      return Colors.transparent;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class SheetElevatedButton extends StatelessWidget {

  const SheetElevatedButton({
    required this.label,
    required this.onPressed,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onPressed,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            border: Border.all(color: _getStrokeColor(states)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Color _getStrokeColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffC8E7D1);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffDCECE0);
    } else {
      return const Color(0xff98C7A6);
    }
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xff62A877);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xff2A8947);
    } else {
      return const Color(0xff3C7D3E);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class SheetIconButton extends StatelessWidget {

  const SheetIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onPressed,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            border: Border.all(color: _getStrokeColor(states)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            icon,
            color: const Color(0xff444746),
          ),
        );
      },
    );
  }

  Color _getStrokeColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffC8E7D1);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffC8E7D1);
    } else {
      return const Color(0xffB5E0C1);
    }
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDFF2E4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF8FCF9);
    } else {
      return const Color(0xffFFFFFF);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _PickerTextField extends StatefulWidget {

  const _PickerTextField({
    required this.controller,
    required this.focusNode,
    required this.areaWidth,
    required this.label,
    required this.formatters,
    required this.onChanged,
    double? textFieldWidth,
  }) : textFieldWidth = textFieldWidth ?? areaWidth;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double areaWidth;
  final double textFieldWidth;
  final String label;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter> formatters;

  @override
  State<StatefulWidget> createState() => _PickerTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('controller', controller));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode));
    properties.add(DoubleProperty('areaWidth', areaWidth));
    properties.add(DoubleProperty('textFieldWidth', textFieldWidth));
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<ValueChanged<String>>.has('onChanged', onChanged));
    properties.add(IterableProperty<TextInputFormatter>('formatters', formatters));
  }
}

class _PickerTextFieldState extends State<_PickerTextField> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.areaWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xff606368),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: widget.textFieldWidth,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff3d4043),
                letterSpacing: -0.3,
              ),
              inputFormatters: widget.formatters,
              onChanged: widget.onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDADCE0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDADCE0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff000000), width: 2),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RGBInputFormatter extends TextInputFormatter {
  RGBInputFormatter({
    this.min = 0,
    this.max = 255,
  }) : assert(min >= 0 && max <= 255);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (newValue.text.length > 3) {
      return oldValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    return newValue;
  }
}

class RGBAHexInputFormatter extends TextInputFormatter {
  RGBAHexInputFormatter({
    this.min = 0,
    this.max = 255,
  }) : assert(min >= 0 && max <= 255);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String allowedCharacters = '#0123456789ABCDEFabcdefABCDEF';

    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.length > 9) {
      return oldValue;
    }

    for (int i = 0; i < newValue.text.length; i++) {
      if (i != 0 && newValue.text[i] == '#') {
        return oldValue;
      }

      if (!allowedCharacters.contains(newValue.text[i])) {
        return oldValue;
      }
    }

    return newValue;
  }
}
