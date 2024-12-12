import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WidgetStateBuilder extends StatefulWidget {
  const WidgetStateBuilder({
    required this.builder,
    this.disableSplash = false,
    this.disabled = false,
    this.cursor,
    this.onHover,
    this.onTap,
    this.selected = false,
    this.focusNode,
    super.key,
  });

  final Widget Function(Set<WidgetState> states) builder;
  final bool disableSplash;
  final bool disabled;
  final MouseCursor? cursor;
  final ValueChanged<bool>? onHover;
  final GestureTapCallback? onTap;
  final bool selected;
  final FocusNode? focusNode;

  @override
  State<StatefulWidget> createState() => _WidgetStateBuilder();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(Set<WidgetState> states)>.has('childBuilder', builder));
    properties.add(DiagnosticsProperty<bool>('disableSplash', disableSplash));
    properties.add(DiagnosticsProperty<bool>('disabled', disabled));
    properties.add(DiagnosticsProperty<MouseCursor?>('mouseCursor', cursor));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onHover', onHover));
    properties.add(ObjectFlagProperty<GestureTapCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
  }
}

class _WidgetStateBuilder extends State<WidgetStateBuilder> {
  final Set<WidgetState> _states = <WidgetState>{};
  Offset? _pointerDownPosition;
  static const double _kTapSlopSquared = 18.0 * 18.0;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_listenFocusNode);
    _setInitialStates();
  }

  @override
  void didUpdateWidget(covariant WidgetStateBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _setInitialStates();
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_listenFocusNode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.3,
          child: widget.builder(<WidgetState>{}),
        ),
      );
    }
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
      cursor: widget.cursor ?? (widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic),
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
        child: widget.builder(_states),
      ),
    );
  }

  void _listenFocusNode() {
    if (widget.focusNode!.hasFocus) {
      _addState(WidgetState.focused);
    } else {
      _removeState(WidgetState.focused);
    }
  }

  void _setInitialStates() {
    if (widget.focusNode != null) {
      if (widget.focusNode!.hasFocus) {
        _addState(WidgetState.focused);
      } else {
        _removeState(WidgetState.focused);
      }
    }
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
