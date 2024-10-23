part of 'asset_icon.dart';

class AssetIconData with EquatableMixin {
  const AssetIconData(this.assetName);

  final String assetName;

  @override
  List<Object> get props => <Object>[assetName];
}
