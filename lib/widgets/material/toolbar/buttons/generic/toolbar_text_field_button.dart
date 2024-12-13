import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarTextFieldButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextFieldButton({
    required Size size,
    required EdgeInsets margin,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextAlign? textAlign,
    Color? backgroundColor,
    String? hintText,
    bool? borderVisible,
    bool? dropdownVisible,
    bool? hoverAnimation,
    super.key,
  })  : _size = size,
        _margin = margin,
        _controller = controller,
        _focusNode = focusNode,
        _textAlign = textAlign ?? TextAlign.center,
        _backgroundColor = backgroundColor,
        _hintText = hintText,
        _borderVisible = borderVisible ?? true,
        _dropdownVisible = dropdownVisible ?? false,
        _hoverAnimation = hoverAnimation ?? true;

  final Size _size;
  final EdgeInsets _margin;
  final TextEditingController _controller;
  final FocusNode _focusNode;
  final TextAlign _textAlign;
  final Color? _backgroundColor;
  final String? _hintText;
  final bool _borderVisible;
  final bool _dropdownVisible;
  final bool _hoverAnimation;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _resolveBackgroundColor(states);
        Color? foregroundColor = _resolveForegroundColor(states);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: _controller,
            textAlign: _textAlign,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff1f1f1f),
              fontFamily: 'GoogleSans',
              package: 'sheets',
              height: 24 / 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            cursorHeight: 14,
            decoration: InputDecoration(
              hintText: _hintText,
              suffixIconConstraints: const BoxConstraints(maxWidth: 20, minWidth: 20),
              suffixIcon: _dropdownVisible
                  ? Container(
                      width: 10,
                      padding: const EdgeInsets.only(right: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AssetIcon(
                          SheetIcons.docs_icon_arrow_dropdown,
                          width: 8,
                          height: 4,
                          color: foregroundColor,
                        ),
                      ),
                    )
                  : null,
              enabledBorder: _borderVisible
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(color: Color(0xff747775)),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: const BorderSide(color: Color(0xff0b57d0), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            ),
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (!_hoverAnimation) {
      return Colors.transparent;
    }
    if (_backgroundColor != null) {
      return _backgroundColor;
    }

    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF1F1F1F);
  }
}
