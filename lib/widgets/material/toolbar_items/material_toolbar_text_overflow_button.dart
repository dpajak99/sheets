import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_options_button.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';

class MaterialTextOverflowButton extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialTextOverflowButton({
    required this.selectedTextOverflow,
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
  final TextOverflowBehavior selectedTextOverflow;
  final ValueChanged<TextOverflowBehavior> onChanged;

  @override
  Widget build(BuildContext context) {
    AssetIconData icon = switch (selectedTextOverflow) {
      TextOverflowBehavior.overflow => SheetIcons.format_text_overflow,
      TextOverflowBehavior.wrap => SheetIcons.format_text_wrap,
      TextOverflowBehavior.clip => SheetIcons.format_text_clip,
    };

    return MaterialToolbarOptionsButton<TextOverflowBehavior>(
      width: width,
      height: height,
      margin: margin,
      icon: icon,
      onSelected: onChanged,
      options: const <IconOptionValue<TextOverflowBehavior>>[
        IconOptionValue<TextOverflowBehavior>(value: TextOverflowBehavior.overflow, icon: SheetIcons.format_text_overflow),
        IconOptionValue<TextOverflowBehavior>(value: TextOverflowBehavior.wrap, icon: SheetIcons.format_text_wrap),
        IconOptionValue<TextOverflowBehavior>(value: TextOverflowBehavior.clip, icon: SheetIcons.format_text_clip),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextOverflowBehavior>('selectedTextOverflow', selectedTextOverflow));
    properties.add(ObjectFlagProperty<ValueChanged<TextOverflowBehavior>>.has('onChanged', onChanged));
  }
}

enum TextOverflowBehavior {
  overflow,
  clip,
  wrap,
}
