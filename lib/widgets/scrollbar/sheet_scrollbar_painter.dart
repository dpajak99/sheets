import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sheets/core/scroll/sheet_axis_direction.dart';
import 'package:sheets/core/scroll/sheet_scroll_metrics.dart';
import 'package:sheets/core/scroll/sheet_scroll_position.dart';

class SheetScrollbarPainter extends ChangeNotifier implements CustomPainter {
  SheetScrollbarPainter({required SheetAxisDirection axisDirection})
      : _axisDirection = axisDirection,
        _metrics = SheetScrollMetrics.zero(axisDirection),
        _position = SheetScrollPosition();

  final SheetAxisDirection _axisDirection;

  late SheetScrollMetrics _metrics;
  set scrollMetrics(SheetScrollMetrics scrollMetrics) {
    if (_metrics == scrollMetrics) return;
    _metrics = scrollMetrics;
    notifyListeners();
  }

  late SheetScrollPosition _position;
  set scrollPosition(SheetScrollPosition scrollPosition) {
    if (_position == scrollPosition) return;
    _position = scrollPosition;
    notifyListeners();
  }

  bool _hovered = false;
  set hovered(bool hovered) {
    if (_hovered == hovered) return;
    _hovered = hovered;
    notifyListeners();
  }

  double _scrollToThumbRatio = 0;

  @override
  bool? hitTest(Offset position) => false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    _paintScrollbar(canvas, size);
  }

  void _paintScrollbar(Canvas canvas, Size size) {
    final double thumbMargin = _hovered ? 0 : 2;
    const double thumbMinSize = 48;

    final Size trackSize = size;
    late Size thumbSize;
    late Offset thumbOffset;

    switch (_axisDirection) {
      case SheetAxisDirection.vertical:
        final double trackHeight = trackSize.height;
        final double availableTrackHeight = trackHeight - (2 * thumbMargin);

        final double ratio = _viewportDimension / _contentSize;
        final double offsetRatio =
            _scrollOffset / (_contentSize - _viewportDimension);

        final double thumbHeight =
            max(availableTrackHeight * ratio, thumbMinSize);
        final double thumbPosition =
            offsetRatio * (availableTrackHeight - thumbHeight) + thumbMargin;

        thumbSize = Size(trackSize.width - (thumbMargin * 2), thumbHeight);
        thumbOffset = Offset(thumbMargin, thumbPosition);

        final double maxScrollPosition = _contentSize - _viewportDimension;
        final double maxThumbOffset = trackHeight - thumbHeight;
        _scrollToThumbRatio = maxScrollPosition / maxThumbOffset;
        break;
      case SheetAxisDirection.horizontal:
        final double trackWidth = trackSize.width;
        final double availableTrackWidth = trackWidth - (2 * thumbMargin);

        final double ratio = _viewportDimension / _contentSize;
        final double offsetRatio =
            _scrollOffset / (_contentSize - _viewportDimension);

        final double thumbWidth =
            max(availableTrackWidth * ratio, thumbMinSize);
        final double thumbPosition =
            offsetRatio * (availableTrackWidth - thumbWidth) + thumbMargin;

        thumbSize = Size(thumbWidth, trackSize.height - (thumbMargin * 2));
        thumbOffset = Offset(thumbPosition, thumbMargin);

        final double maxScrollPosition = _contentSize - _viewportDimension;
        final double maxThumbOffset = trackWidth - thumbWidth;
        _scrollToThumbRatio = maxScrollPosition / maxThumbOffset;
        break;
    }

    _paintTrack(canvas, trackSize);
    _paintThumb(canvas, thumbSize, thumbOffset);
  }

  double get _viewportDimension => _metrics.viewportDimension;
  double get _contentSize => _metrics.contentSize;
  double get _scrollOffset => _position.offset;

  double parseDeltaToRealScroll(double delta) => delta * _scrollToThumbRatio;

  void _paintTrack(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintThumb(Canvas canvas, Size size, Offset offset) {
    final Paint paint = Paint()
      ..color = _hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(offset & size, const Radius.circular(16)),
      paint,
    );
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant SheetScrollbarPainter oldDelegate) =>
      false;

  @override
  bool shouldRepaint(covariant SheetScrollbarPainter oldDelegate) {
    return oldDelegate._metrics != _metrics ||
        oldDelegate._position != _position;
  }
}
