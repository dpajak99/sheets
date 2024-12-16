import 'package:flutter/material.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogColorMenuIndicator extends StatelessWidget {
  const GoogColorMenuIndicator({
    required Color color,
    required StaticSizeWidget child,
    super.key,
  })  : _child = child,
        _color = color;

  final Color _color;
  final StaticSizeWidget _child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _child,
        Positioned(
          bottom: 6,
          left: 6,
          right: 5,
          child: MouseRegion(
            opaque: false,
            cursor: SystemMouseCursors.click,
            child:Container(
              height: 4,
              decoration: BoxDecoration(color: _color),
            ),
          ),
        ),
      ],
    );
  }
}
