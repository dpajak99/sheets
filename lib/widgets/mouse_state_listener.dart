import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MouseStateListener extends StatefulWidget {
  const MouseStateListener({
    required this.childBuilder,
    this.disableSplash = false,
    this.disabled = false,
    this.mouseCursor,
    this.onHover,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final Widget Function(Set<WidgetState> states) childBuilder;
  final bool disableSplash;
  final bool disabled;
  final MouseCursor? mouseCursor;
  final ValueChanged<bool>? onHover;
  final GestureTapCallback? onTap;
  final bool selected;

  @override
  State<StatefulWidget> createState() => _MouseStateListener();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(Set<WidgetState> states)>.has('childBuilder', childBuilder));
    properties.add(DiagnosticsProperty<bool>('disableSplash', disableSplash));
    properties.add(DiagnosticsProperty<bool>('disabled', disabled));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', mouseCursor));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<GestureTapCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
  }
}

class _MouseStateListener extends State<MouseStateListener> {
  final Set<WidgetState> _states = <WidgetState>{};
  Offset? _pointerDownPosition;
  static const double _kTapSlopSquared = 18.0 * 18.0;

  @override
  void initState() {
    super.initState();
    _setInitialStates();
  }

  @override
  void didUpdateWidget(covariant MouseStateListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setInitialStates();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) {
        _addState(WidgetState.hovered);
        widget.onHover?.call(true);
      },
      onExit: (PointerExitEvent event) {
        _removeState(WidgetState.hovered);
        _removeState(WidgetState.pressed);
        widget.onHover?.call(false);
      },
      cursor: widget.mouseCursor ?? (widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic),
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          _pointerDownPosition = event.position;
          _addState(WidgetState.pressed);
        },
        onPointerUp: (PointerUpEvent event) {
          _removeState(WidgetState.pressed);
          if (_pointerDownPosition != null) {
            Offset offset = event.position - _pointerDownPosition!;
            if (offset.distanceSquared <= _kTapSlopSquared) {
              widget.onTap?.call();
            }
            _pointerDownPosition = null;
          }
        },
        onPointerCancel: (PointerCancelEvent event) {
          _removeState(WidgetState.pressed);
          _pointerDownPosition = null;
        },
        child: widget.childBuilder(_states),
      ),
    );
  }

  void _setInitialStates() {
    if (widget.disabled) {
      _states.add(WidgetState.disabled);
    } else {
      _states.remove(WidgetState.disabled);
    }
    if (widget.selected) {
      _states.add(WidgetState.selected);
    } else {
      _states.remove(WidgetState.selected);
    }
  }

  void _addState(WidgetState state) {
    _states.add(state);
    setState(() {});
  }

  void _removeState(WidgetState state) {
    _states.remove(state);
    setState(() {});
  }
}
