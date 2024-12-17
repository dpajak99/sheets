import 'package:flutter/material.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogColorIndicator extends StatelessWidget {
  const GoogColorIndicator({
    required Color color,
    required StaticSizeWidget child,
    double? width,
    Offset? lbPosition,
    super.key,
  })  : _child = child,
        _color = color,
        _width = width ?? 23,
        _lbPosition = lbPosition ?? const Offset(6, 6);

  final double _width;
  final Offset _lbPosition;
  final Color _color;
  final StaticSizeWidget _child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _child,
        Positioned(
          bottom: _lbPosition.dy,
          left: _lbPosition.dx,
          width: _width,
          child: MouseRegion(
            opaque: false,
            cursor: SystemMouseCursors.click,
            child: Container(
              height: 4,
              decoration: BoxDecoration(color: _color),
            ),
          ),
        ),
      ],
    );
  }
}
