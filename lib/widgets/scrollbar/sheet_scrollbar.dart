import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sheets/widgets/sheet_mouse_region.dart';
import 'package:sheets/widgets/widget_state_builder.dart';
import 'sheet_scrollbar_painter.dart';

class SheetScrollbar extends StatefulWidget {
  const SheetScrollbar({
    required this.painter,
    required this.onScroll,
    required this.deltaModifier,
    super.key,
  });

  final SheetScrollbarPainter painter;
  final ValueChanged<double> onScroll;
  final double Function(Offset offset) deltaModifier;

  @override
  State<SheetScrollbar> createState() => _SheetScrollbarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SheetScrollbarPainter>('painter', painter));
    properties.add(
        ObjectFlagProperty<ValueChanged<double>>.has('onScroll', onScroll));
    properties.add(ObjectFlagProperty<double Function(Offset offset)>.has(
        'deltaModifier', deltaModifier));
  }
}

class _SheetScrollbarState extends State<SheetScrollbar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SheetMouseRegion(
        key: UniqueKey(),
        cursor: SystemMouseCursors.basic,
        onEnter: _onHover,
        onExit: _onExit,
        onDragUpdate: _onScroll,
        child: CustomPaint(painter: widget.painter),
      ),
    );
  }

  void _onScroll(PointerMoveEvent event) {
    final double delta = widget.deltaModifier(event.delta);
    final double updatedDelta = widget.painter.parseDeltaToRealScroll(delta);
    widget.onScroll(updatedDelta);
  }

  void _onHover() => widget.painter.hovered = true;
  void _onExit() => widget.painter.hovered = false;
}

class ScrollbarButton extends StatelessWidget {
  const ScrollbarButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: onPressed,
      cursor: SystemMouseCursors.basic,
      builder: (Set<WidgetState> states) {
        return Container(
          width: size,
          height: size,
          color: _backgroundColor(states),
          child: Center(child: Icon(icon, size: 12, color: _iconColor(states))),
        );
      },
    );
  }

  Color _backgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xff919191);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffc1c1c1);
    } else {
      return const Color(0xfff8f8f8);
    }
  }

  Color _iconColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.white;
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xff767676);
    } else {
      return const Color(0xff989898);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DoubleProperty('size', size));
  }
}
