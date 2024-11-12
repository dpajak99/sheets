import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_button_item_mixin.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

class MaterialToolbarTextButton extends StatelessWidget with MaterialToolbarItemMixin, MaterialToolbarButtonMixin {
  const MaterialToolbarTextButton({
    required this.text,
    required this.onTap,
    this.width = 32,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    this.active = false,
    this.pressed = false,
    super.key,
  });

  @override
  final bool active;
  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final bool pressed;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          ...states,
        };

        Color? backgroundColor = getBackgroundColor(updatedStates);
        Color? foregroundColor = getForegroundColor(updatedStates);

        return Container(
          width: width,
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              text,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('pressed', pressed));
  }
}
