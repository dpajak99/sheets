import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogBottomBarButton extends StatelessWidget {
  const GoogBottomBarButton({
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final VoidCallback onPressed;
  final AssetIconData icon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
  }

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: () {},
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        return Container(
          width: 34,
          height: 34,
          padding: const EdgeInsets.only(top: 12, bottom: 11),
          decoration: BoxDecoration(
            color: states.contains(WidgetState.hovered) ? const Color(0xffE8EBEE) : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AssetIcon(
              icon,
              color: const Color(0xff444746),
            ),
          ),
        );
      },
    );
  }
}
