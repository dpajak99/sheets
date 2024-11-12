import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_options_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';

class MaterialTextHorizontalAlignButton extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialTextHorizontalAlignButton({
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
  final TextAlign selectedTextAlign;
  final ValueChanged<TextAlign> onChanged;

  @override
  Widget build(BuildContext context) {
    AssetIconData icon = switch (selectedTextAlign) {
      TextAlign.start => SheetIcons.format_align_left,
      TextAlign.left => SheetIcons.format_align_left,
      TextAlign.center => SheetIcons.format_align_center,
      TextAlign.right => SheetIcons.format_align_right,
      TextAlign.end => SheetIcons.format_align_right,
      TextAlign.justify => SheetIcons.format_align_justify,
    };

    return MaterialToolbarOptionsButton<TextAlign>(
      width: width,
      height: height,
      margin: margin,
      icon: icon,
      onSelected: onChanged,
      options: const <IconOptionValue<TextAlign>>[
        IconOptionValue<TextAlign>(value: TextAlign.left, icon: SheetIcons.format_align_left),
        IconOptionValue<TextAlign>(value: TextAlign.center, icon: SheetIcons.format_align_center),
        IconOptionValue<TextAlign>(value: TextAlign.right, icon: SheetIcons.format_align_right),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', selectedTextAlign));
    properties.add(ObjectFlagProperty<ValueChanged<TextAlign>>.has('onChanged', onChanged));
  }
}
