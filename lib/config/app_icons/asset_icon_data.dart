part of 'asset_icon.dart';

class AssetIconData with EquatableMixin {
  final String assetName;

  const AssetIconData(this.assetName);

  @override
  List<Object> get props => <Object>[assetName];
}
