import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogToolbarComboButton extends StatelessWidget implements StaticSizeWidget {
  GoogToolbarComboButton({
    required Size size,
    required EdgeInsets margin,
    required TextEditingController controller,
    required FocusNode focusNode,
    GoogToolbarComboButtonStyle? style,
    GoogToolbarComboButtonInputDecoration? decoration,
    super.key,
  })  : _size = size,
        _margin = margin,
        _controller = controller,
        _focusNode = focusNode,
        _style = style ?? GoogToolbarComboButtonStyle.defaultStyle(),
        _decoration = decoration ?? GoogToolbarComboButtonInputDecoration();

  final Size _size;
  final EdgeInsets _margin;
  final FocusNode _focusNode;
  final TextEditingController _controller;
  final GoogToolbarComboButtonStyle _style;
  final GoogToolbarComboButtonInputDecoration _decoration;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _style.backgroundColor.resolve(states);
        Color? foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: GoogToolbarComboButtonInput(
            focusNode: _focusNode,
            controller: _controller,
            decoration: _decoration,
            foregroundColor: foregroundColor,
          ),
        );
      },
    );
  }
}

class GoogToolbarComboButtonStyle {
  const GoogToolbarComboButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory GoogToolbarComboButtonStyle.defaultStyle() {
    WidgetStateProperty<Color> backgroundColor = WidgetStateProperty.all(Colors.transparent);

    WidgetStateProperty<Color> foregroundColor = WidgetStateProperty.all(const Color(0xFF1F1F1F));

    return GoogToolbarComboButtonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  GoogToolbarComboButtonStyle copyWith({
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? foregroundColor,
  }) {
    return GoogToolbarComboButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
    );
  }

  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
}

class GoogToolbarComboButtonInputDecoration {
  GoogToolbarComboButtonInputDecoration({
    this.hasDropdown = false,
    this.hintText,
    this.textAlign = TextAlign.center,
    InputBorder? border,
    InputBorder? focusedBorder,
    TextStyle? textStyle,
  })  : border = border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(color: Color(0xff747775)),
            ),
        focusedBorder = focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: const BorderSide(color: Color(0xff0b57d0), width: 2),
            ),
        textStyle = textStyle ??
            const TextStyle(
              fontSize: 14,
              color: Color(0xff1f1f1f),
              fontFamily: 'GoogleSans',
              package: 'sheets',
              height: 24 / 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            );

  GoogToolbarComboButtonInputDecoration copyWith({
    bool? hasDropdown,
    String? hintText,
    TextAlign? textAlign,
    TextStyle? textStyle,
    InputBorder? border,
    InputBorder? focusedBorder,
  }) {
    return GoogToolbarComboButtonInputDecoration(
      hasDropdown: hasDropdown ?? this.hasDropdown,
      hintText: hintText ?? this.hintText,
      textAlign: textAlign ?? this.textAlign,
      textStyle: textStyle ?? this.textStyle,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
    );
  }

  final bool hasDropdown;
  final String? hintText;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
}

class GoogToolbarComboButtonInput extends StatelessWidget {
  GoogToolbarComboButtonInput({
    required Color foregroundColor,
    required FocusNode focusNode,
    required TextEditingController controller,
    GoogToolbarComboButtonInputDecoration? decoration,
    super.key,
  })  : _foregroundColor = foregroundColor,
        _focusNode = focusNode,
        _controller = controller,
        _decoration = decoration ?? GoogToolbarComboButtonInputDecoration();

  final Color _foregroundColor;
  final FocusNode _focusNode;
  final TextEditingController _controller;
  final GoogToolbarComboButtonInputDecoration _decoration;

  @override
  Widget build(BuildContext context) {
    InputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Colors.transparent, ),
    );
    InputBorder border = _decoration.border ?? defaultBorder;
    InputBorder focusedBorder = _decoration.focusedBorder ?? defaultBorder;

    if(border.borderSide == BorderSide.none) {
      border = defaultBorder;
    }
    if(focusedBorder.borderSide == BorderSide.none) {
      focusedBorder = defaultBorder;
    }

    return TextField(
      focusNode: _focusNode,
      controller: _controller,
      textAlign: _decoration.textAlign,
      textAlignVertical: TextAlignVertical.center,
      style: _decoration.textStyle.copyWith(
        color: _foregroundColor,
      ),
      cursorHeight: _decoration.textStyle.fontSize,
      decoration: InputDecoration(
        isDense: true,
        hintText: _decoration.hintText,
        suffixIconConstraints: const BoxConstraints(maxWidth: 20, minWidth: 20),
        suffixIcon: _decoration.hasDropdown
            ? Container(
                width: 10,
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AssetIcon(
                    SheetIcons.docs_icon_arrow_dropdown,
                    width: 8,
                    height: 4,
                    color: _foregroundColor,
                  ),
                ),
              )
            : null,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      ),
    );
  }
}
