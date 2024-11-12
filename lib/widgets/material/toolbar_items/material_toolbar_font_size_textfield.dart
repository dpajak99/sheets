import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sheets/widgets/material/toolbar_items/mixins/material_toolbar_item_mixin.dart';

class MaterialToolbarFontSizeTextfield extends StatelessWidget with MaterialToolbarItemMixin {
  const MaterialToolbarFontSizeTextfield({
    required this.selectedFontSize,
    required this.onChanged,
    this.width = 40,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  final double selectedFontSize;
  final ValueChanged<double> onChanged;
  @override
  final double width;
  @override
  final double height;
  @override
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff444746);
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: Border.all(color: foregroundColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          selectedFontSize.toStringAsFixed(0),
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontFamily: 'GoogleSans',
            package: 'sheets',
            color: foregroundColor,
            fontSize: 15,
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('selectedFontSize', selectedFontSize));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged));
  }
}