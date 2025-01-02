import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_combo_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarFontSizeBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarFontSizeBtn({
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
  State<StatefulWidget> createState() => _GoogToolbarFontSizeBtnState();
}

class _GoogToolbarFontSizeBtnState extends State<GoogToolbarFontSizeBtn> {
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
  void didUpdateWidget(covariant GoogToolbarFontSizeBtn oldWidget) {
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
        return GoogToolbarComboButton(
          focusNode: _focusNode,
          controller: _textController,
          size: widget.size,
          margin: widget.margin,
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
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
    return GoogMenuItem(
      iconPlaceholderVisible: false,
      label: GoogText('$_size', textAlign: TextAlign.center),
      onPressed: _onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
