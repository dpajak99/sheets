import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

part 'asset_icon_data.dart';

part 'sheet_icons.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon(
    this.assetIconData, {
    this.size = 24,
    this.width,
    this.height,
    this.color,
    super.key,
  });

  final AssetIconData assetIconData;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('assetIconData', assetIconData));
    properties.add(DoubleProperty('size', size));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(ColorProperty('color', color));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: SvgPicture.asset(
        assetIconData.assetName,
        package: 'sheets',
        width: width ?? size,
        height: height ?? size,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
