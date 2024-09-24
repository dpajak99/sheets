import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/controller/sheet_scroll_controller.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/sheet_scroll_metrics.dart';
import 'package:sheets/utils/mouse_state_listener.dart';

class SheetScrollable extends StatefulWidget {
  final SheetScrollController scrollController;
  final Widget child;

  const SheetScrollable({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<SheetScrollable> createState() => SheetScrollableState();
}

class SheetScrollableState extends State<SheetScrollable> {
  final SheetScrollbarPainter verticalScrollbarPainter = SheetScrollbarPainter(axisDirection: SheetAxisDirection.vertical);
  final SheetScrollbarPainter horizontalScrollbarPainter = SheetScrollbarPainter(axisDirection: SheetAxisDirection.horizontal);

  @override
  void initState() {
    super.initState();

    widget.scrollController.position.vertical.addListener(_updateVerticalPosition);
    widget.scrollController.position.horizontal.addListener(_updateHorizontalPosition);
    widget.scrollController.metrics.addListener(_updateMetrics);

    _updateVerticalPosition();
    _updateHorizontalPosition();
    _updateMetrics();
  }

  void _updateVerticalPosition() {
    verticalScrollbarPainter.scrollPosition = widget.scrollController.position.vertical;
  }

  void _updateHorizontalPosition() {
    horizontalScrollbarPainter.scrollPosition = widget.scrollController.position.horizontal;
  }

  void _updateMetrics() {
    verticalScrollbarPainter.scrollMetrics = widget.scrollController.metrics.vertical;
    horizontalScrollbarPainter.scrollMetrics = widget.scrollController.metrics.horizontal;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          widget.scrollController.scrollBy(event.scrollDelta);
        }
      },
      child: _ScrollbarLayout(
        verticalScrollbar: CustomPaint(painter: verticalScrollbarPainter),
        horizontalScrollbar: CustomPaint(painter: horizontalScrollbarPainter),
        child: widget.child,
      ),
    );

    // return Column(
    //   children: [
    //     Expanded(
    //       child: Row(
    //         children: [
    //           Expanded(child: child),
    //           Container(
    //             width: scrollbarWidth,
    //             decoration: BoxDecoration(
    //               color: const Color(0xfff8f8f8),
    //               border: Border(
    //                 left: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
    //                 right: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
    //               ),
    //             ),
    //             child: Column(
    //               children: [
    //                 Container(height: columnHeadersHeight),
    //                 Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //                 Expanded(
    //                   child: Container(
    //                     decoration: const BoxDecoration(color: Colors.white),
    //                     child: VerticalScrollbar(sheetController: sheetController),
    //                   ),
    //                 ),
    //                 Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //                 // ScrollbarButton(
    //                 //   size: innerHeight,
    //                 //   icon: Icons.arrow_drop_up,
    //                 //   onPressed: () {
    //                 //     sheetController.cursorController.scrollBy(const Offset(0, -20));
    //                 //   },
    //                 // ),
    //                 // Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //                 // ScrollbarButton(
    //                 //   size: innerHeight,
    //                 //   icon: Icons.arrow_drop_down,
    //                 //   onPressed: () {
    //                 //     sheetController.cursorController.scrollBy(const Offset(0, 20));
    //                 //   },
    //                 // ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       height: scrollbarWidth,
    //       decoration: BoxDecoration(
    //         color: const Color(0xfff8f8f8),
    //         border: Border(
    //           top: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
    //           bottom: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
    //         ),
    //       ),
    //       child: Row(
    //         children: [
    //           Container(width: rowHeadersWidth),
    //           VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //           Expanded(
    //             child: Container(
    //               decoration: const BoxDecoration(color: Colors.white),
    //               child: HorizontalScrollbar(sheetController: sheetController),
    //             ),
    //           ),
    //           VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //           // ScrollbarButton(
    //           //   size: innerHeight,
    //           //   icon: Icons.arrow_left,
    //           //   onPressed: () {
    //           //     sheetController.cursorController.scrollBy(const Offset(-20, 0));
    //           //   },
    //           // ),
    //           // VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //           // ScrollbarButton(
    //           //   size: innerHeight,
    //           //   icon: Icons.arrow_right,
    //           //   onPressed: () {
    //           //     sheetController.cursorController.scrollBy(const Offset(20, 0));
    //           //   },
    //           // ),
    //           VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
    //           // SizedBox(width: innerHeight, height: innerHeight),
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }
}

class _ScrollbarLayout extends StatelessWidget {
  final Widget verticalScrollbar;
  final Widget horizontalScrollbar;
  final Widget child;
  final double scrollbarWeight;

  _ScrollbarLayout({
    required this.verticalScrollbar,
    required this.horizontalScrollbar,
    required this.child,
  }) : scrollbarWeight = scrollbarWidth - borderWidth * 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: child),
              SizedBox(width: scrollbarWeight, height: double.infinity, child: verticalScrollbar),
            ],
          ),
        ),
        SizedBox(height: scrollbarWeight, width: double.infinity, child: horizontalScrollbar)
      ],
    );
  }
}

class SheetScrollbarPainter extends ChangeNotifier implements CustomPainter {
  final SheetAxisDirection axisDirection;

  SheetScrollbarPainter({
    required this.axisDirection,
  })  : _lastScrollMetrics = SheetScrollMetrics.zero(axisDirection),
        _lastScrollPosition = SheetScrollPosition();

  late SheetScrollMetrics _lastScrollMetrics;

  set scrollMetrics(SheetScrollMetrics scrollMetrics) {
    if (_lastScrollMetrics == scrollMetrics) return;
    _lastScrollMetrics = scrollMetrics;
    notifyListeners();
  }

  late SheetScrollPosition _lastScrollPosition;

  set scrollPosition(SheetScrollPosition scrollPosition) {
    if (_lastScrollPosition == scrollPosition) return;
    _lastScrollPosition = scrollPosition;
    notifyListeners();
  }

  @override
  bool? hitTest(Offset position) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintScrollbar(canvas, size);
  }

  void _paintScrollbar(Canvas canvas, Size size) {
    Size thumbSize, trackSize;
    Offset thumbOffset;

    double thumbWidth = _lastScrollMetrics.viewportDimension * (_lastScrollMetrics.viewportDimension / _lastScrollMetrics.maxScrollExtent);
    double thumbPosition = _lastScrollPosition.offset / (_lastScrollMetrics.maxScrollExtent) * _lastScrollMetrics.viewportDimension;

    switch (axisDirection) {
      case SheetAxisDirection.vertical:
        trackSize = size;
        thumbSize = Size(trackSize.width, thumbWidth);
        thumbOffset = Offset(0, thumbPosition);
        break;
      case SheetAxisDirection.horizontal:
        trackSize = size;
        thumbSize = Size(thumbWidth, trackSize.height);
        thumbOffset = Offset(thumbPosition, 0);
        break;
    }

    _paintTrack(canvas, trackSize);
    _paintThumb(canvas, thumbSize, thumbOffset);
  }

  void _paintTrack(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintThumb(Canvas canvas, Size size, Offset offset) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRect(offset & size, paint);
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(covariant SheetScrollbarPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRepaint(covariant SheetScrollbarPainter oldDelegate) {
    return oldDelegate._lastScrollMetrics != _lastScrollMetrics || oldDelegate._lastScrollPosition != _lastScrollPosition;
  }
}

class ScrollbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const ScrollbarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onPressed,
      mouseCursor: SystemMouseCursors.basic,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          width: size,
          height: size,
          color: getBackgroundColor(states),
          child: Center(
            child: Icon(icon, size: 12, color: getIconColor(states)),
          ),
        );
      },
    );
  }

  Color getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffbdc1c6);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffc2c2c2);
    } else {
      return Colors.white;
    }
  }

  Color getIconColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.white;
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xff767676);
    } else {
      return const Color(0xff989898);
    }
  }
}

class VerticalScrollbar extends StatefulWidget {
  final SheetControllerOld sheetController;

  const VerticalScrollbar({
    super.key,
    required this.sheetController,
  });

  @override
  State<VerticalScrollbar> createState() => VerticalScrollbarState();
}

class VerticalScrollbarState extends State<VerticalScrollbar> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        double delta = (details.primaryDelta ?? 0) * 3;
        widget.sheetController.cursorController.scrollBy(Offset(0, delta));
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: Padding(
          padding: EdgeInsets.all(hovered ? 0 : 2),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Size viewportSize = constraints.biggest;
              return Stack(
                fit: StackFit.expand,
                children: [
                  // ValueListenableBuilder(
                  //   valueListenable: widget.sheetController.scrollController.position.verticalScrollListener,
                  //   builder: (BuildContext context, double value, _) {
                  //     double scrollbarHeight = viewportSize.height * (viewportSize.height / (widget.sheetController.scrollController.contentHeight + 60));
                  //     double marginTop = value / (widget.sheetController.scrollController.contentHeight + 60) * viewportSize.height;
                  //
                  //     return Positioned(
                  //       top: marginTop,
                  //       child: Container(
                  //         height: scrollbarHeight,
                  //         width: viewportSize.width,
                  //         decoration: BoxDecoration(
                  //           color: hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0),
                  //           borderRadius: BorderRadius.circular(16),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HorizontalScrollbar extends StatefulWidget {
  final SheetControllerOld sheetController;

  const HorizontalScrollbar({
    super.key,
    required this.sheetController,
  });

  @override
  State<HorizontalScrollbar> createState() => HorizontalScrollbarState();
}

class HorizontalScrollbarState extends State<HorizontalScrollbar> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        double delta = (details.primaryDelta ?? 0) * 2;
        widget.sheetController.cursorController.scrollBy(Offset(delta, 0));
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        child: Padding(
          padding: EdgeInsets.all(hovered ? 0 : 2),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Size viewportSize = constraints.biggest;
              return Stack(
                fit: StackFit.expand,
                children: [
                  // ValueListenableBuilder(
                  //   valueListenable: widget.sheetController.scrollController.position.horizontalScrollListener,
                  //   builder: (BuildContext context, double value, _) {
                  //     double scrollbarWidth = viewportSize.width * (viewportSize.width / (widget.sheetController.scrollController.contentWidth - 24));
                  //     double marginLeft = value / (widget.sheetController.scrollController.contentWidth - 24) * viewportSize.width;
                  //
                  //     return Positioned(
                  //       left: marginLeft,
                  //       child: Container(
                  //         width: scrollbarWidth,
                  //         height: viewportSize.height,
                  //         decoration: BoxDecoration(
                  //           color: hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0),
                  //           borderRadius: BorderRadius.circular(16),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
