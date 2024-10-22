import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

part 'asset_icon_data.dart';

part 'sheet_icons.dart';

class AssetIcon extends StatelessWidget {
  final AssetIconData assetIconData;
  final double size;
  final Color? color;

  const AssetIcon(
    this.assetIconData, {
    this.size = 24,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        assetIconData.assetName,
        width: size,
        height: size,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
