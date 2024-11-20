import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/extensions/iterable_extensions.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class DropdownGridMenu extends StatelessWidget {
  const DropdownGridMenu({
    required List<Widget> children,
    required double gap,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    int? columns,
    Widget? trailing,
    super.key,
  })  : _children = children,
        _gap = gap,
        _backgroundColor = backgroundColor ?? const Color(0xfff0f4f9),
        _borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(3)),
        _padding = padding ??
            ((trailing != null)
                ? const EdgeInsets.only(left: 10, right: 4, top: 12, bottom: 12)
                : const EdgeInsets.symmetric(horizontal: 7, vertical: 9)),
        _columns = columns,
        _trailing = trailing;

  final List<Widget> _children;
  final double _gap;
  final Color _backgroundColor;
  final BorderRadius _borderRadius;
  final EdgeInsets _padding;
  final int? _columns;
  final Widget? _trailing;

  @override
  Widget build(BuildContext context) {
    Widget child = _DropdownGrid(
      itemCount: _children.length,
      gap: _gap,
      builder: (BuildContext context, int index) => _children[index],
      columns: _columns,
    );

    if (_trailing != null) {
      child = Row(
        children: <Widget>[
          child,
          const SizedBox(width: 1),
          const VerticalDivider(color: Color(0xffeeeeee), width: 1, thickness: 1),
          const SizedBox(width: 8),
          _trailing,
        ],
      );
    }
    return _DropdownGridMenuLayout(
      backgroundColor: _backgroundColor,
      borderRadius: _borderRadius,
      padding: _padding,
      child: child,
    );
  }
}

class DropdownGridMenuItem extends StatelessWidget {
  const DropdownGridMenuItem({
    required bool selected,
    required AssetIconData icon,
    required VoidCallback onPressed,
    double? iconSize,
    double? size,
    super.key,
  })  : _selected = selected,
        _icon = icon,
        _onPressed = onPressed,
        _iconSize = iconSize ?? 19,
        _size = size ?? 28;

  const DropdownGridMenuItem.medium({
    required bool selected,
    required AssetIconData icon,
    required VoidCallback onPressed,
    double? iconSize,
    Key? key,
  }) : this(
          selected: selected,
          icon: icon,
          onPressed: onPressed,
          iconSize: iconSize,
          size: 32,
          key: key,
        );

  final bool _selected;
  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final double _iconSize;
  final double _size;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Color backgroundColor = _resolveBackgroundColor(states);
        Color foregroundColor = _resolveForegroundColor(states);

        return Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: AssetIcon(_icon, size: _iconSize, color: foregroundColor),
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xFFD3E3FD);
    } else if (states.contains(WidgetState.pressed)) {
      return const Color(0xFFDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xFFE4E7EA);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    if (_selected) {
      return const Color(0xFF041E49);
    } else {
      return const Color(0xFF444746);
    }
  }
}

class _DropdownGridMenuLayout extends StatelessWidget {
  const _DropdownGridMenuLayout({
    required Widget child,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required EdgeInsets padding,
  })  : _child = child,
        _backgroundColor = backgroundColor,
        _borderRadius = borderRadius,
        _padding = padding;

  final Widget _child;
  final Color _backgroundColor;
  final BorderRadius _borderRadius;
  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        boxShadow: const <BoxShadow>[MaterialSheetTheme.materialShadow],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: _borderRadius,
        child: _child,
      ),
    );
  }
}

class _DropdownGrid extends StatelessWidget {
  const _DropdownGrid({
    required int itemCount,
    required double gap,
    required IndexedWidgetBuilder builder,
    int? columns,
  })  : _itemCount = itemCount,
        _gap = gap,
        _builder = builder,
        _columns = columns;

  final int _itemCount;
  final double _gap;
  final IndexedWidgetBuilder _builder;
  final int? _columns;

  @override
  Widget build(BuildContext context) {
    if (_columns == null) {
      return Row(
        children: <Widget>[for (int i = 0; i < _itemCount; i++) _builder(context, i)].withDivider(SizedBox(width: _gap)),
      );
    } else {
      int rows = (_itemCount / _columns).ceil();
      return Column(
        children: <Widget>[
          for (int i = 0; i < rows; i++)
            Row(
              children: <Widget>[
                for (int j = 0; j < _columns; j++)
                  if (i * _columns + j < _itemCount) _builder(context, i * _columns + j)
              ].withDivider(SizedBox(width: _gap)),
            ),
        ].withDivider(SizedBox(height: _gap)),
      );
    }
  }
}
