import 'package:flutter/material.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class MaterialIconRectButton extends StatelessWidget {
  const MaterialIconRectButton({
    required IconData icon,
    required VoidCallback onPressed,
    super.key,
  })  : _icon = icon,
        _onPressed = onPressed;

  final IconData _icon;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            border: Border.all(color: _getStrokeColor(states)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Icon(
            _icon,
            color: const Color(0xff444746),
          ),
        );
      },
    );
  }

  Color _getStrokeColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffC8E7D1);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffC8E7D1);
    } else {
      return const Color(0xffB5E0C1);
    }
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDFF2E4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF8FCF9);
    } else {
      return const Color(0xffFFFFFF);
    }
  }
}
