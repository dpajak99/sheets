import 'package:flutter/material.dart';
import 'package:sheets/controller/sheet_controller.dart';
import 'package:sheets/sheet_constants.dart';
import 'package:sheets/utils/mouse_state_listener.dart';

class ScrollWrapper extends StatelessWidget {
  final SheetController sheetController;
  final Widget child;

  const ScrollWrapper({
    super.key,
    required this.child,
    required this.sheetController,
  });

  @override
  Widget build(BuildContext context) {
    double innerHeight = scrollbarWidth - borderWidth * 2;

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: child),
              Container(
                width: scrollbarWidth,
                decoration: BoxDecoration(
                  color: const Color(0xfff8f8f8),
                  border: Border(
                    left: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
                    right: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
                  ),
                ),
                child: Column(
                  children: [
                    Container(height: columnHeadersHeight),
                    Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: VerticalScrollbar(sheetController: sheetController),
                      ),
                    ),
                    Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
                    ScrollbarButton(
                      size: innerHeight,
                      icon: Icons.arrow_drop_up,
                      onPressed: () {
                        sheetController.cursorController.scrollBy(const Offset(0, -20));
                      },
                    ),
                    Divider(height: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
                    ScrollbarButton(
                      size: innerHeight,
                      icon: Icons.arrow_drop_down,
                      onPressed: () {
                        sheetController.cursorController.scrollBy(const Offset(0, 20));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: scrollbarWidth,
          decoration: BoxDecoration(
            color: const Color(0xfff8f8f8),
            border: Border(
              top: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
              bottom: BorderSide(width: borderWidth, color: const Color(0xffe1e3e1)),
            ),
          ),
          child: Row(
            children: [
              Container(width: rowHeadersWidth),
              VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: HorizontalScrollbar(sheetController: sheetController),
                ),
              ),
              VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
              ScrollbarButton(
                size: innerHeight,
                icon: Icons.arrow_left,
                onPressed: () {
                  sheetController.cursorController.scrollBy(const Offset(-20, 0));
                },
              ),
              VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
              ScrollbarButton(
                size: innerHeight,
                icon: Icons.arrow_right,
                onPressed: () {
                  sheetController.cursorController.scrollBy(const Offset(20, 0));
                },
              ),
              VerticalDivider(width: borderWidth, thickness: borderWidth, color: const Color(0xffd9d9d9)),
              SizedBox(width: innerHeight, height: innerHeight),
            ],
          ),
        )
      ],
    );
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
  final SheetController sheetController;

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
                  ValueListenableBuilder(
                    valueListenable: widget.sheetController.scrollController.position.verticalScrollListener,
                    builder: (BuildContext context, double value, _) {
                      double scrollbarHeight = viewportSize.height * (viewportSize.height / (widget.sheetController.scrollController.contentHeight + 60));
                      double marginTop = value / (widget.sheetController.scrollController.contentHeight + 60) * viewportSize.height;

                      return Positioned(
                        top: marginTop,
                        child: Container(
                          height: scrollbarHeight,
                          width: viewportSize.width,
                          decoration: BoxDecoration(
                            color: hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
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
  final SheetController sheetController;

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
                  ValueListenableBuilder(
                    valueListenable: widget.sheetController.scrollController.position.horizontalScrollListener,
                    builder: (BuildContext context, double value, _) {
                      double scrollbarWidth = viewportSize.width * (viewportSize.width / (widget.sheetController.scrollController.contentWidth - 24));
                      double marginLeft = value / (widget.sheetController.scrollController.contentWidth - 24) * viewportSize.width;

                      return Positioned(
                        left: marginLeft,
                        child: Container(
                          width: scrollbarWidth,
                          height: viewportSize.height,
                          decoration: BoxDecoration(
                            color: hovered ? const Color(0xffbdc1c6) : const Color(0xffdadce0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
