import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarSearchbox extends StatelessWidget implements StaticSizeWidget {
  const ToolbarSearchbox.expanded({
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _size = size ?? const Size(100, 28),
        _margin = margin ?? const EdgeInsets.only(right: 2),
        _expanded = true;

  const ToolbarSearchbox.collapsed({
    Size? size,
    EdgeInsets? margin,
    super.key,
  })  : _size = size ?? const Size(37, 28),
        _margin = margin ?? const EdgeInsets.only(right: 2),
        _expanded = false;

  final bool _expanded;
  final Size _size;
  final EdgeInsets _margin;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  Widget build(BuildContext context) {
    if (_expanded) {
      return _ExpandedSearchbox(size: _size, margin: _margin);
    } else {
      return _CollapsedSearchbox(size: _size, margin: _margin);
    }
  }
}

class _ExpandedSearchbox extends StatelessWidget {
  const _ExpandedSearchbox({
    required Size size,
    required EdgeInsets margin,
  })  : _size = size,
        _margin = margin;

  final Size _size;
  final EdgeInsets _margin;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff444746);

    return Container(
      width: _size.width,
      height: _size.height,
      margin: _margin,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: <Widget>[
          AssetIcon(SheetIcons.docs_icon_search_20_nv50, size: 19, color: foregroundColor),
          const SizedBox(width: 7),
          Text(
            'Menu',
            style: TextStyle(
              fontFamily: 'GoogleSans',
              package: 'sheets',
              color: foregroundColor,
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedSearchbox extends StatelessWidget {
  const _CollapsedSearchbox({
    required Size size,
    required EdgeInsets margin,
  })  : _size = size,
        _margin = margin;

  final Size _size;
  final EdgeInsets _margin;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      builder: (Set<WidgetState> states) {
        Color? backgroundColor = _resolveBackgroundColor(states);
        Color? foregroundColor = _resolveForegroundColor(states);

        return Container(
          width: _size.width,
          height: _size.height,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: AssetIcon(SheetIcons.docs_icon_search_20_nv50, size: 19, color: foregroundColor),
          ),
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return const Color(0xffF1F4F9);
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xff444746);
  }
}
