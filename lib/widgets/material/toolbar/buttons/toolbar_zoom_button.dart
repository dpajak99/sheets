import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_text_field_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarZoomButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarZoomButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Size get size => const Size(77, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarZoomButtonState();
}

class _ToolbarZoomButtonState extends State<ToolbarZoomButton> {
  static final List<int> _predefinedTextSizes = <int>[50, 75, 90, 100, 125, 150, 200];
  late final FocusNode _focusNode;
  late final DropdownButtonController _dropdownController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _dropdownController = DropdownButtonController();
    _textController = TextEditingController(text: '${widget.value.toInt()}%');

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _dropdownController.open();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ToolbarZoomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _textController.text = '${widget.value.toInt()}%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      disabled: true,
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return ToolbarTextFieldButton(
          focusNode: _focusNode,
          controller: _textController,
          size: widget.size,
          margin: widget.margin,
          borderVisible: false,
          dropdownVisible: true,
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 67,
          children: _predefinedTextSizes.map((int size) {
            return _ZoomSizeOption(
              size: size,
              onPressed: () => widget.onChanged(widget.value),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ZoomSizeOption extends StatelessWidget {
  const _ZoomSizeOption({
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
      label: '$_size%',
      labelStyle: const TextStyle(fontWeight: FontWeight.w400),
      onPressed: _onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
