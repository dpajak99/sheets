import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class SheetFooterActionButton extends StatelessWidget {
  const SheetFooterActionButton({
    required this.onPressed,
    required this.icon,
    required this.iconSize,
    super.key,
  });

  final VoidCallback onPressed;
  final AssetIconData icon;
  final double iconSize;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(DoubleProperty('iconSize', iconSize));
  }

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
      mouseCursor: SystemMouseCursors.click,
      childBuilder: (Set<WidgetState> states) {
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: states.contains(WidgetState.hovered) ? const Color(0xffE8EBEE) : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AssetIcon(
              icon,
              size: iconSize,
              color: const Color(0xff444746),
            ),
          ),
        );
      },
    );
  }
}
