import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextFieldButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextFieldButton({
    required Size size,
    required EdgeInsets margin,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool? borderVisible,
    bool? dropdownVisible,
    super.key,
  })  : _size = size,
        _margin = margin,
        _controller = controller,
        _focusNode = focusNode,
        _borderVisible = borderVisible ?? true,
        _dropdownVisible = dropdownVisible ?? false;

  final Size _size;
  final EdgeInsets _margin;
  final TextEditingController _controller;
  final FocusNode _focusNode;
  final bool _borderVisible;
  final bool _dropdownVisible;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff1f1f1f);

    return Container(
      width: _size.width,
      height: _size.height,
      margin: _margin,
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        textAlign: TextAlign.center,
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
          suffixIconConstraints: const BoxConstraints(maxWidth: 20, minWidth: 20),
          suffixIcon: _dropdownVisible
              ? Container(
                  width: 10,
                  padding: const EdgeInsets.only(right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AssetIcon(
                      SheetIcons.dropdown,
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
  }
}
