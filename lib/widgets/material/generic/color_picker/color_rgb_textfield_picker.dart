import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheets/widgets/material/generic/material_labeled_textfield.dart';

class ColorRGBTextfieldPicker extends StatefulWidget {
  const ColorRGBTextfieldPicker({
    required this.color,
    required this.onChanged,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<StatefulWidget> createState() => _ColorRGBTextfieldPickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(ObjectFlagProperty<ValueChanged<Color>>.has('onChanged', onChanged));
  }
}

class _ColorRGBTextfieldPickerState extends State<ColorRGBTextfieldPicker> {
  late final _ColorController _redController;
  late final _ColorController _greenController;
  late final _ColorController _blueController;

  @override
  void initState() {
    super.initState();
    _redController = _ColorController(() => widget.color.red);
    _greenController = _ColorController(() => widget.color.green);
    _blueController = _ColorController(() => widget.color.blue);
  }

  @override
  void dispose() {
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ColorRGBTextfieldPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      if (_redController.hasFocus || _greenController.hasFocus || _blueController.hasFocus) {
        return;
      }
      _redController.refresh();
      _greenController.refresh();
      _blueController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        MaterialLabeledTextField(
          focusNode: _redController.focusNode,
          controller: _redController.controller,
          width: 43,
          label: 'R',
          formatters: <TextInputFormatter>[_ColorRGBInputFormatter()],
          onChanged: (String value) {
            int? red = value.isEmpty ? 0 : int.tryParse(value);
            _onColorChanged(red: red);
          },
        ),
        const SizedBox(width: 8),
        MaterialLabeledTextField(
          focusNode: _greenController.focusNode,
          controller: _greenController.controller,
          width: 43,
          label: 'G',
          formatters: <TextInputFormatter>[_ColorRGBInputFormatter()],
          onChanged: (String value) {
            int? green = value.isEmpty ? 0 : int.tryParse(value);
            _onColorChanged(green: green);
          },
        ),
        const SizedBox(width: 8),
        MaterialLabeledTextField(
          focusNode: _blueController.focusNode,
          controller: _blueController.controller,
          width: 43,
          label: 'B',
          formatters: <TextInputFormatter>[_ColorRGBInputFormatter()],
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
      (green != null && green >= 0 && green <= 255) ? green : widget.color.green,
      (blue != null && blue >= 0 && blue <= 255) ? blue : widget.color.blue,
    ));
  }
}

class _ColorRGBInputFormatter extends TextInputFormatter {
  _ColorRGBInputFormatter({
    this.min = 0,
    this.max = 255,
  }) : assert(min >= 0 && max <= 255, 'Value must be between min and max');

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

    int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    return newValue;
  }
}

class _ColorController {
  _ColorController(this._colorBuilder) {
    controller = TextEditingController();
    controller.text = _colorBuilder().toString();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        controller.text = _colorBuilder().toString();
      }
    });
  }

  late final FocusNode focusNode;
  late final TextEditingController controller;
  late final int Function() _colorBuilder;

  void refresh() {
    controller.text = _colorBuilder().toString();
  }

  bool get hasFocus => focusNode.hasFocus;

  void dispose() {
    focusNode.dispose();
    controller.dispose();
  }
}
