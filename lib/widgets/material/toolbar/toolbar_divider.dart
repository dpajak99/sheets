import 'package:flutter/material.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarDivider extends StatelessWidget implements StaticSizeWidget {
  const ToolbarDivider({
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _size = size ?? const Size(1, 20),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 3);

  final Size _size;
  final EdgeInsets _margin;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _size.height,
      margin: _margin,
      child: VerticalDivider(color: const Color(0xffc7c7c7), width: _size.width, thickness: _size.width),
    );
  }
}
