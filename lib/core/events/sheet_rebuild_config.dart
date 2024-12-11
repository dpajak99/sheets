import 'package:equatable/equatable.dart';

class SheetRebuildConfig with EquatableMixin {
  SheetRebuildConfig({
    bool rebuildViewport = false,
    bool rebuildData = false,
    bool rebuildSelection = false,
    bool rebuildVerticalScroll = false,
    bool rebuildHorizontalScroll = false,
  }) : _rebuildHorizontalScroll = rebuildHorizontalScroll, _rebuildVerticalScroll = rebuildVerticalScroll, _rebuildSelection = rebuildSelection, _rebuildData = rebuildData, _rebuildViewport = rebuildViewport;

  SheetRebuildConfig.all()
      : _rebuildViewport = true,
        _rebuildData = true,
        _rebuildSelection = true,
        _rebuildVerticalScroll = true,
        _rebuildHorizontalScroll = true;

  final bool _rebuildViewport;
  final bool _rebuildData;
  final bool _rebuildSelection;
  final bool _rebuildVerticalScroll;
  final bool _rebuildHorizontalScroll;

  SheetRebuildConfig combine(SheetRebuildConfig other) {
    return SheetRebuildConfig(
      rebuildViewport: _rebuildViewport || other._rebuildViewport,
      rebuildData: _rebuildData || other._rebuildData,
      rebuildSelection: _rebuildSelection || other._rebuildSelection,
      rebuildVerticalScroll: _rebuildVerticalScroll || other._rebuildVerticalScroll,
      rebuildHorizontalScroll: _rebuildHorizontalScroll || other._rebuildHorizontalScroll,
    );
  }

  bool get rebuildViewport => _rebuildViewport;

  bool get _rebuildScroll => _rebuildVerticalScroll || _rebuildHorizontalScroll;

  bool get rebuildSelection => rebuildViewport || _rebuildSelection || _rebuildScroll;

  bool get rebuildCellsLayer => _rebuildData || _rebuildScroll || _rebuildViewport;

  bool get rebuildFillHandle => rebuildSelection;

  bool get rebuildHorizontalHeaders => _rebuildHorizontalScroll || _rebuildSelection;

  bool get rebuildVerticalHeaders => _rebuildVerticalScroll || _rebuildSelection;

  @override
  List<Object?> get props => <Object?>[_rebuildViewport, _rebuildData, _rebuildSelection, _rebuildVerticalScroll, _rebuildHorizontalScroll];
}
