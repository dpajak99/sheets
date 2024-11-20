import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/dropdown_button.dart';
import 'package:sheets/widgets/material/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_text_field_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarFontSizeButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarFontSizeButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Size get size => const Size(34, 24);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarFontSizeButtonState();
}

class _ToolbarFontSizeButtonState extends State<ToolbarFontSizeButton> {
  static final List<int> _predefinedTextSizes = <int>[6, 7, 8, 9, 10, 11, 12, 14, 18, 24, 36];
  late final FocusNode _focusNode;
  late final DropdownButtonController _dropdownController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _dropdownController = DropdownButtonController();
    _textController = TextEditingController(text: '${widget.value.toInt()}');

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _dropdownController.open();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ToolbarFontSizeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _textController.text = '${widget.value.toInt()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarTextFieldButton(
          focusNode: _focusNode,
          controller: _textController,
          size: widget.size,
          margin: widget.margin,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 41,
          children: _predefinedTextSizes.map((int size) {
            return _FontSizeOption(
              size: size,
              onPressed: () {
                widget.onChanged(size.toDouble());
                _dropdownController.close();
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _FontSizeOption extends StatelessWidget {
  const _FontSizeOption({
    required int size,
    required VoidCallback onPressed,
  })  : _size = size,
        _onPressed = onPressed;

  final int _size;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return DropdownListMenuItem(
      iconPlaceholderVisible: false,
      label: '$_size',
      labelAlign: TextAlign.center,
      onPressed: _onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
