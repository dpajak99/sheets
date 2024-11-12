import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_options_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';

class MaterialTextVerticalAlignButton extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialTextVerticalAlignButton({
    required this.selectedTextAlign,
    required this.onChanged,
    this.width = 39,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;
  final TextVerticalAlign selectedTextAlign;
  final ValueChanged<TextVerticalAlign> onChanged;

  @override
  Widget build(BuildContext context) {
    AssetIconData icon = switch (selectedTextAlign) {
      TextVerticalAlign.top => SheetIcons.vertical_align_top,
      TextVerticalAlign.center => SheetIcons.vertical_align_center,
      TextVerticalAlign.bottom => SheetIcons.vertical_align_bottom,
    };

    return MaterialToolbarOptionsButton<TextVerticalAlign>(
      width: width,
      height: height,
      margin: margin,
      icon: icon,
      onSelected: onChanged,
      options: const <IconOptionValue<TextVerticalAlign>>[
        IconOptionValue<TextVerticalAlign>(value: TextVerticalAlign.top, icon: SheetIcons.vertical_align_top),
        IconOptionValue<TextVerticalAlign>(value: TextVerticalAlign.center, icon: SheetIcons.vertical_align_center),
        IconOptionValue<TextVerticalAlign>(value: TextVerticalAlign.bottom, icon: SheetIcons.vertical_align_bottom),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextVerticalAlign>('selectedTextAlign', selectedTextAlign));
    properties.add(ObjectFlagProperty<ValueChanged<TextVerticalAlign>>.has('onChanged', onChanged));
  }

}

enum TextVerticalAlign {
  top,
  center,
  bottom,
}
