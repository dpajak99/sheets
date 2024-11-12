import 'package:flutter/material.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';

class MaterialToolbarDivider extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialToolbarDivider({
    this.width = 1,
    this.height = 20,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    super.key,
  });

  @override
  final double width;

  @override
  final double height;

  @override
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: VerticalDivider(color: const Color(0xffc7c7c7), width: width, thickness: width),
    );
  }
}
