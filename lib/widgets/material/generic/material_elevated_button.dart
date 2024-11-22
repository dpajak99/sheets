import 'package:flutter/material.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class MaterialElevatedButton extends StatelessWidget {
  const MaterialElevatedButton({
    required String label,
    required VoidCallback onPressed,
    super.key,
  })  : _label = label,
        _onPressed = onPressed;

  final String _label;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            border: Border.all(color: _getStrokeColor(states)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            _label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Color _getStrokeColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffC8E7D1);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffDCECE0);
    } else {
      return const Color(0xff98C7A6);
    }
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xff62A877);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xff2A8947);
    } else {
      return const Color(0xff3C7D3E);
    }
  }
}
