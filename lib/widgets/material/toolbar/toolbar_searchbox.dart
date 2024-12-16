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
    Color foregroundColor = const Color(0xff444746);
    Widget icon = Padding(
      padding: const EdgeInsets.only(left: 11, right: 12, top: 7, bottom: 7),
      child: AssetIcon(SheetIcons.docs_icon_search_20, color: foregroundColor),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: Container(
        width: _size.width,
        height: _size.height,
        margin: _margin,
        decoration: BoxDecoration(
          color: _expanded ? Colors.white : Colors.transparent,
        ),
        child: Row(
          children: <Widget>[
            if (!_expanded) ...<Widget>[
              WidgetStateBuilder(
                builder: (Set<WidgetState> states) {
                  Color? backgroundColor = _resolveBackgroundColor(states);

                  return Container(
                    width: _size.width,
                    height: _size.height,
                    decoration: BoxDecoration(color: backgroundColor),
                    child: icon,
                  );
                },
              ),
            ],
            if (_expanded) ...<Widget>[
              icon,
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
          ],
        ),
      ),
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return const Color(0xffF1F4F9);
    }
  }
}
