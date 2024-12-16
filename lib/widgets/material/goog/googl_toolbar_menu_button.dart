import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogToolbarMenuButton extends StatelessWidget implements StaticSizeWidget {
  GoogToolbarMenuButton({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onDropdownTap,
    bool? disabled,
    bool? selected,
    double? width,
    double? height,
    GoogToolbarButtonStyle? style,
    EdgeInsets? margin,
    EdgeInsets? childPadding,
    super.key,
  })  : _child = child,
        _onTap = onTap,
        _onDropdownTap = onDropdownTap,
        _selected = selected ?? false,
        _disabled = disabled ?? false,
        _width = width ?? (onDropdownTap != null ? 42 : 39),
        _height = height ?? 30,
        _style = style ?? GoogToolbarButtonStyle.defaultStyle(),
        _margin = margin ?? const EdgeInsets.all(1),
        _childPadding = childPadding ?? const EdgeInsets.only(top: 9, bottom: 7);

  final bool _selected;
  final bool _disabled;
  final double _width;
  final double _height;
  final GoogToolbarButtonStyle _style;
  final Widget _child;
  final VoidCallback? _onTap;
  final VoidCallback? _onDropdownTap;
  final EdgeInsets _margin;
  final EdgeInsets _childPadding;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => Size(_width, _height);

  @override
  Widget build(BuildContext context) {
    if (_onDropdownTap != null) {
      return Container(
        width: _width,
        height: _height,
        margin: _margin,
        child: Row(
          children: <Widget>[
            Expanded(
              child: WidgetStateBuilder(
                onTap: _onTap,
                disabled: _disabled,
                cursor: SystemMouseCursors.click,
                builder: _buildIcon,
              ),
            ),
            const SizedBox(width: 2),
            WidgetStateBuilder(
              onTap: _onDropdownTap,
              disabled: _disabled,
              cursor: SystemMouseCursors.click,
              builder: _buildDropdown,
            ),
          ],
        ),
      );
    } else {
      return WidgetStateBuilder(
        onTap: _onTap,
        disabled: _disabled,
        cursor: SystemMouseCursors.click,
        builder: (Set<WidgetState> states) {
          return Container(
            width: _width,
            height: _height,
            margin: _margin,
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildIcon(states),
                ),
                _buildDropdown(states),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildIcon(Set<WidgetState> states) {
    Set<WidgetState> updatedStates = <WidgetState>{
      if (_selected) WidgetState.selected,
      ...states,
    };
    Color backgroundColor = _style.backgroundColor.resolve(updatedStates);
    Color foregroundColor = _style.foregroundColor.resolve(updatedStates);

    return Container(
      height: double.infinity,
      padding: _childPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(3),
          bottomLeft: Radius.circular(3),
        ),
      ),
      child: GoogIconTheme(
        color: foregroundColor,
        child: _child,
      ),
    );
  }

  Widget _buildDropdown(Set<WidgetState> states) {
    Color backgroundColor = _style.backgroundColor.resolve(states);
    Color foregroundColor = _style.foregroundColor.resolve(states);

    return Container(
      width: 12,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AssetIcon(
            SheetIcons.docs_icon_arrow_dropdown,
            width: 8,
            height: 4,
            color: foregroundColor,
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
