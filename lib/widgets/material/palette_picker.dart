import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// PalettePicker widget allows selection of a color value based on position.
class PalettePicker extends StatefulWidget {
  const PalettePicker({
    required this.color,
    required this.position,
    required this.onChanged,
    required this.leftRightColors,
    required this.topBottomColors,
    super.key,
    this.leftPosition = 0.0,
    this.rightPosition = 1.0,
    this.topPosition = 0.0,
    this.bottomPosition = 1.0,
    this.border,
    this.borderRadius,
  });

  final Color color;
  final Offset position;
  final ValueChanged<Offset> onChanged;
  final double leftPosition;
  final double rightPosition;
  final List<Color> leftRightColors;
  final double topPosition;
  final double bottomPosition;
  final List<Color> topBottomColors;
  final Border? border;
  final BorderRadius? borderRadius;

  @override
  State<StatefulWidget> createState() => _PalettePickerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Offset>('position', position));
    properties.add(ObjectFlagProperty<ValueChanged<Offset>>.has('onChanged', onChanged));
    properties.add(DoubleProperty('leftPosition', leftPosition));
    properties.add(DoubleProperty('rightPosition', rightPosition));
    properties.add(IterableProperty<Color>('leftRightColors', leftRightColors));
    properties.add(DoubleProperty('topPosition', topPosition));
    properties.add(DoubleProperty('bottomPosition', bottomPosition));
    properties.add(IterableProperty<Color>('topBottomColors', topBottomColors));
    properties.add(DiagnosticsProperty<Border?>('border', border));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
  }
}

class _PalettePickerState extends State<PalettePicker> {
  Offset get _ratio {
    double ratioX = ((widget.position.dx - widget.leftPosition) / (widget.rightPosition - widget.leftPosition)).clamp(0.0, 1.0);
    double ratioY = ((widget.position.dy - widget.topPosition) / (widget.bottomPosition - widget.topPosition)).clamp(0.0, 1.0);
    return Offset(ratioX, ratioY);
  }

  void _updatePosition(Offset localPosition, Size size) {
    double dx = localPosition.dx.clamp(0.0, size.width);
    double dy = localPosition.dy.clamp(0.0, size.height);

    double ratioX = dx / size.width;
    double ratioY = dy / size.height;

    double positionX = widget.leftPosition + ratioX * (widget.rightPosition - widget.leftPosition);
    double positionY = widget.topPosition + ratioY * (widget.bottomPosition - widget.topPosition);

    widget.onChanged(Offset(positionX, positionY));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition, context.size!);
  }

  void _onTapDown(TapDownDetails details) {
    _updatePosition(details.localPosition, context.size!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Left-Right Gradient
        Container(
          decoration: BoxDecoration(
            border: widget.border,
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(colors: widget.leftRightColors),
          ),
        ),
        // Top-Bottom Gradient
        Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.topBottomColors,
            ),
          ),
        ),
        // Gesture Detector and Thumb Painter
        GestureDetector(
          onPanUpdate: _onPanUpdate,
          onTapDown: _onTapDown,
          child: CustomPaint(
            size: Size.infinite,
            painter: _PalettePainter(
              color: widget.color,
              ratio: _ratio,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the palette thumb.
class _PalettePainter extends CustomPainter {
  _PalettePainter({
    required this.ratio,
    required this.color,
  });

  final Offset ratio;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(
      size.width * ratio.dx,
      size.height * ratio.dy,
    );

    Paint paintWhite = Paint()..color = Colors.white;
    Paint paintColor = Paint()..color = color;

    Path circlePath = Path()..addOval(Rect.fromCircle(center: offset + const Offset(0, -1), radius: 11));

    canvas.drawShadow(circlePath, const Color(0xAA000000), 2, true);
    canvas.drawCircle(offset, 10, paintWhite);
    canvas.drawCircle(offset, 8, paintColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
