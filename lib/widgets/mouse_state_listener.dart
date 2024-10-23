import 'package:flutter/foundation.dart';
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
      cursor: widget.mouseCursor ?? (widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.none),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          _addState(WidgetState.pressed);
        },
        onTapUp: (TapUpDetails details) {
          _removeState(WidgetState.pressed);
        },
        onTapCancel: () {
          _removeState(WidgetState.pressed);
        },
        child: InkWell(
          onTap: widget.onTap != null ? () => widget.onTap!() : null,
          splashFactory: widget.disableSplash ? NoSplash.splashFactory : null,
          splashColor: widget.disableSplash ? Colors.transparent : null,
          highlightColor: widget.disableSplash ? Colors.transparent : null,
          hoverColor: widget.disableSplash ? Colors.transparent : null,
          onHover: (bool hovered) {
            if (hovered) {
              _addState(WidgetState.hovered);
            } else {
              _removeState(WidgetState.hovered);
              _removeState(WidgetState.pressed);
            }
            widget.onHover?.call(hovered);
          },
          child: widget.childBuilder(_states),
        ),
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
