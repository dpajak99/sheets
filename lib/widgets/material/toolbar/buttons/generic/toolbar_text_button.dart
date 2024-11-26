import 'package:flutter/material.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarTextButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarTextButton({
    required String text,
    VoidCallback? onTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    super.key,
  })  : _text = text,
        _onTap = onTap,
        _size = size ?? const Size(32, 30),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _opened = opened ?? false,
        _selected = selected ?? false;

  final String _text;
  final VoidCallback? _onTap;
  final Size _size;
  final EdgeInsets _margin;
  final bool _opened;
  final bool _selected;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onTap,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (_opened) WidgetState.pressed,
          ...states,
        };
        Color? backgroundColor = _resolveBackgroundColor(updatedStates);
        Color? foregroundColor = _resolveForegroundColor(updatedStates);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'GoogleSans',
                package: 'sheets',
                fontSize: 13,
                height: 1,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xffD8E2F9);
    } else if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xFF041E49);
    } else {
      return const Color(0xFF444746);
    }
  }
}
