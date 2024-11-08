import 'package:flutter/material.dart';

/// SliderPicker widget allows selection of a value between [min] and [max].
class SliderPicker extends StatefulWidget {
  const SliderPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.colors,
    this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(3)),
    this.border,
    this.width = 40.0,
    this.height = 40.0,
  }) : assert(value >= min && value <= max);

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final List<Color>? colors;
  final Widget? child;
  final BorderRadius borderRadius;
  final Border? border;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() => _SliderPickerState();
}

class _SliderPickerState extends State<SliderPicker> {
  final GlobalKey _sliderKey = GlobalKey();

  double get _ratio => ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  void _updateValue(Offset localPosition) {
    final RenderBox renderBox = _sliderKey.currentContext?.findRenderObject() as RenderBox;
    final double ratio = localPosition.dx / renderBox.size.width;
    final double newValue = (ratio * (widget.max - widget.min) + widget.min).clamp(widget.min, widget.max);
    widget.onChanged(newValue);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateValue(details.localPosition);
  }

  void _onTapDown(TapDownDetails details) {
    _updateValue(details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    final double thumbSize = widget.height * 2;
    final double thumbPosition = (_ratio * (widget.width - thumbSize / 2)).clamp(0.0, widget.width - thumbSize);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: _onPanUpdate,
      onTapDown: _onTapDown,
      child: SizedBox(
        key: _sliderKey,
        width: widget.width,
        height: widget.height * 2,
        child: Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            // Track
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                border: widget.border,
                gradient: widget.colors != null ? LinearGradient(colors: widget.colors!) : null,
              ),
              child: widget.colors == null
                  ? ClipRRect(
                      borderRadius: widget.borderRadius,
                      child: widget.child,
                    )
                  : null,
            ),
            // Thumb
            Positioned(
              left: thumbPosition,
              child: _Thumb(
                size: thumbSize,
                hue: (widget.value).clamp(widget.min, widget.max),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Private Thumb widget to represent the draggable thumb.
class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.size,
    required this.hue,
  });

  final double size;
  final double hue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ThumbPainter(
        hue: hue,
      ),
    );
  }
}

/// Custom painter for the thumb.
class _ThumbPainter extends CustomPainter {
  _ThumbPainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paintWhite = Paint()..color = Colors.white;
    final Paint paintColor = Paint()..color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();

    Path circlePath = Path()..addOval(Rect.fromCircle(center: center + const Offset(0, -1), radius: size.width / 2 + 1));

    canvas.drawShadow(circlePath, const Color(0xAA000000), 2, true);

    canvas.drawCircle(center, size.width / 2, paintWhite);
    canvas.drawCircle(center, size.width / 2 - 2, paintColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
