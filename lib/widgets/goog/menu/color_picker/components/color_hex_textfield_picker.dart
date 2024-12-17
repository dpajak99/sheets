import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/utils/color_utils.dart';
import 'package:sheets/widgets/material/generic/material_labeled_textfield.dart';

class ColorHEXTextfieldPicker extends StatefulWidget {
  const ColorHEXTextfieldPicker({
    required this.color,
    required this.onChanged,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<StatefulWidget> createState() => _ColorHEXTextfieldPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
  }
}

class _ColorHEXTextfieldPickerState extends State<ColorHEXTextfieldPicker> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = _formatColor(widget.color);

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.text = _formatColor(widget.color);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialLabeledTextField(
      focusNode: _focusNode,
      width: 95,
      textFieldWidth: 75,
      label: 'Hex',
      controller: _controller,
      formatters: <TextInputFormatter>[_ColorHEXInputFormatter()],
      onChanged: _handleTextFieldChanged,
    );
  }

  void _handleTextFieldChanged(String value) {
    Color color = _parseColor(value);
    widget.onChanged(color);
  }

  String _formatColor(Color color) {
    return '#${ColorUtils.colorToInt(color).toRadixString(16).padLeft(8, '0')}';
  }

  Color _parseColor(String value) {
    String parsedValue = value.startsWith('#') ? value.substring(1) : value;
    return Color(int.parse(parsedValue, radix: 16));
  }
}

class _ColorHEXInputFormatter extends TextInputFormatter {
  _ColorHEXInputFormatter({
    this.min = 0,
    this.max = 255,
  }) : assert(min >= 0 && max <= 255, 'Value must be between min and max');

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String allowedCharacters = '#0123456789ABCDEFabcdefABCDEF';

    if (newValue.text.isEmpty) {
      return newValue;
    }

    bool isPrefixedHex = newValue.text.startsWith('#') && newValue.text.length <= 9;
    bool isHex = !newValue.text.startsWith('#') && newValue.text.length <= 8;
    if (!isPrefixedHex && !isHex) {
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
