import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialToolbarPopup extends StatelessWidget {
  const MaterialToolbarPopup({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: 215,
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: child,
      ),
    );
  }
}

class MaterialToolbarPopupDivider extends StatelessWidget {
  const MaterialToolbarPopupDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Center(
        child: Container(
          height: 1,
          width: double.infinity,
          color: const Color(0xffdadce0),
        ),
      ),
    );
  }
}

class MaterialPopupButton extends StatelessWidget {
  const MaterialPopupButton({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
      childBuilder: (Set<WidgetState> states) {
        return Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _getBackgroundColor(states),
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 16, color: const Color(0xff444746)),
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff444746),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffe8eaed);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffF1F3F4);
    } else {
      return Colors.white;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('text', text));
  }
}

class MaterialPopupLabel extends StatelessWidget {
  const MaterialPopupLabel({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 9, bottom: 12, left: 12, right: 12),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xff444746),
          letterSpacing: 11 * (-0.03),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
  }
}
