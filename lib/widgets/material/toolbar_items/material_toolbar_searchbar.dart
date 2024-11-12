import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialToolbarSearchbar extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialToolbarSearchbar.expanded({
    this.width = 100,
    this.height = 28,
    this.margin = const EdgeInsets.only(right: 2),
    super.key,
  }) : expanded = true;

  const MaterialToolbarSearchbar.collapsed({
    this.width = 37,
    this.height = 28,
    this.margin = const EdgeInsets.only(right: 2),
    super.key,
  }) : expanded = false;

  final bool expanded;
  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff444746);

    if (expanded) {
      return Container(
        width: width,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          children: <Widget>[
            AssetIcon(SheetIcons.search, size: 19, color: foregroundColor),
            const SizedBox(width: 7),
            Text(
              'Menu',
              style: TextStyle(
                fontFamily: 'GoogleSans',
                package: 'sheets',
                color: foregroundColor,
                fontSize: 15,
                height: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    } else {
      return MouseStateListener(
        onTap: () {},
        childBuilder: (Set<WidgetState> states) {
          Color? backgroundColor = _getBackgroundColor(states);

          return Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: AssetIcon(SheetIcons.search, size: 19, color: foregroundColor),
            ),
          );
        },
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('expanded', expanded));
  }

  Color _getBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return const Color(0xffF1F4F9);
    }
  }
}
