import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/extensions/iterable_extensions.dart';
import 'package:sheets/widgets/material/material_sheet_theme.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogPalette extends StatelessWidget {
  const GoogPalette({
    required List<Widget> children,
    required double gap,
    Color? backgroundColor,
    EdgeInsets? padding,
    int? columns,
    Widget? trailing,
    super.key,
  })
      : _children = children,
        _gap = gap,
        _backgroundColor = backgroundColor ?? const Color(0xfff0f4f9),
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
        _columns = columns,
        _trailing = trailing;

  final List<Widget> _children;
  final double _gap;
  final Color _backgroundColor;
  final EdgeInsets _padding;
  final int? _columns;
  final Widget? _trailing;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(3);
    Widget child = _GoogPaletteTable(
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
          SizedBox(
            height: _columns != null ? (_children.length / _columns).ceil() * 32 : 32,
            child: const VerticalDivider(
              color: Color(0xffdadce0),
              width: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(width: 8),
          _trailing,
        ],
      );
    }

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: borderRadius,
        boxShadow: const <BoxShadow>[MaterialSheetTheme.materialShadow],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class GoogPaletteItemStyle {
  GoogPaletteItemStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.opacity,
  });

  factory GoogPaletteItemStyle.defaultStyle() {
    WidgetStateProperty<Color> backgroundColor = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFD3E3FD);
      } else if (states.contains(WidgetState.pressed)) {
        return const Color(0xFFDDDFE4);
      } else if (states.contains(WidgetState.hovered)) {
        return const Color(0xFFE4E7EA);
      } else {
        return Colors.transparent;
      }
    });

    WidgetStateProperty<Color> foregroundColor = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF041E49);
      } else {
        return const Color(0xFF444746);
      }
    });

    WidgetStateProperty<double> opacity = WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return 0.3;
      } else {
        return 1;
      }
    });

    return GoogPaletteItemStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      opacity: opacity,
    );
  }

  GoogPaletteItemStyle copyWith({
    WidgetStateProperty<Color>? backgroundColor,
    WidgetStateProperty<Color>? foregroundColor,
    WidgetStateProperty<double>? opacity,
  }) {
    return GoogPaletteItemStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      opacity: opacity ?? this.opacity,
    );
  }


  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
  final WidgetStateProperty<double> opacity;
}

class GoogPaletteItem extends StatelessWidget {
  GoogPaletteItem({
    required AssetIconData icon,
    required VoidCallback onPressed,
    bool? selected,
    GoogPaletteItemStyle? style,
    double? size,
    EdgeInsets? padding,
    super.key,
  })
      : _selected = selected ?? false,
        _icon = icon,
        _onPressed = onPressed,
        _style = style ?? GoogPaletteItemStyle.defaultStyle(),
        _size = size ?? 28,
        _padding = padding ?? const EdgeInsets.only(top: 8, bottom: 6);

  final bool _selected;
  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final GoogPaletteItemStyle _style;
  final double _size;
  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          if(_selected) WidgetState.selected,
          ...states,
        };
        Color backgroundColor = _style.backgroundColor.resolve(updatedStates);
        Color foregroundColor = _style.foregroundColor.resolve(updatedStates);

        return Container(
          width: _size,
          height: _size,
          padding: _padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: AssetIcon(_icon, color: foregroundColor),
          ),
        );
      },
    );
  }
}

class _GoogPaletteTable extends StatelessWidget {
  const _GoogPaletteTable({
    required int itemCount,
    required double gap,
    required IndexedWidgetBuilder builder,
    int? columns,
  })
      : _itemCount = itemCount,
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
