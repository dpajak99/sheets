import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_combo_button.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarZoomBtn extends StatefulWidget implements StaticSizeWidget {
  const GoogToolbarZoomBtn({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Size get size => const Size(74, 28);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _GoogToolbarZoomBtnState();
}

class _GoogToolbarZoomBtnState extends State<GoogToolbarZoomBtn> {
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
  void didUpdateWidget(covariant GoogToolbarZoomBtn oldWidget) {
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
        return GoogToolbarComboButton(
          focusNode: _focusNode,
          controller: _textController,
          size: widget.size,
          margin: widget.margin,
          decoration: GoogToolbarComboButtonInputDecoration(
            hasDropdown: true,
            textAlign: TextAlign.left,
            border: InputBorder.none
          ),
          style: GoogToolbarComboButtonStyle.defaultStyle().copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              if(states.contains(WidgetState.hovered)) {
                return const Color(0xffe2e7ea);
              } else {
                return Colors.transparent;
              }
            }),
          )
        );
      },
      popupBuilder: (BuildContext context) {
        return GoogMenuVertical(
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
    return GoogMenuItem(
      iconPlaceholderVisible: false,
      label: GoogText('$_size%', fontWeight: FontWeight.w400),
      onPressed: _onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
