import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/goog_icon_theme.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class ToolbarIconButton extends StatelessWidget implements StaticSizeWidget {
  const ToolbarIconButton({
    required AssetIconData icon,
    VoidCallback? onTap,
    VoidCallback? onDropdownTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? hasDropdown,
    bool? disabled,
    super.key,
  })  : _hasDropdown = hasDropdown ?? false,
        _icon = icon,
        _onTap = onTap,
        _onDropdownTap = onDropdownTap,
        _size = size ?? const Size(30, 30),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 1),
        _opened = opened ?? false,
        _selected = selected ?? false,
        _disabled = disabled ?? false;

  const ToolbarIconButton.small({
    required AssetIconData icon,
    VoidCallback? onTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? disabled,
    Key? key,
  }) : this(
          hasDropdown: false,
          icon: icon,
          onTap: onTap,
          size: size ?? const Size(24, 24),
          margin: margin,
          opened: opened,
          selected: selected,
          disabled: disabled,
          key: key,
        );

  const ToolbarIconButton.withDropdown({
    required AssetIconData icon,
    VoidCallback? onTap,
    VoidCallback? onDropdownTap,
    Size? size,
    EdgeInsets? margin,
    bool? opened,
    bool? selected,
    bool? disabled,
    Key? key,
  }) : this(
          hasDropdown: true,
          icon: icon,
          onTap: onTap,
          onDropdownTap: onDropdownTap,
          size: size ?? const Size(39, 30),
          margin: margin,
          opened: opened,
          selected: selected,
          disabled: disabled,
          key: key,
        );

  final AssetIconData _icon;
  final VoidCallback? _onTap;
  final VoidCallback? _onDropdownTap;
  final Size _size;
  final EdgeInsets _margin;
  final bool _opened;
  final bool _selected;
  final bool _hasDropdown;
  final bool _disabled;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => _size;

  @override
  Widget build(BuildContext context) {
    if (_hasDropdown && _onDropdownTap == null) {
      // Treat the entire button as a single unit
      return WidgetStateBuilder(
        disabled: _disabled,
        onTap: _onTap ?? () {},
        builder: (Set<WidgetState> states) {
          Set<WidgetState> updatedStates = <WidgetState>{
            if (_selected) WidgetState.selected,
            ...states,
          };

          Color backgroundColor = _resolveBackgroundColor(updatedStates);
          Color foregroundColor = _resolveForegroundColor(updatedStates);

          return Container(
            width: _size.width,
            height: _size.height,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: AssetIcon(_icon, color: foregroundColor, size: 14),
                  ),
                ),
                _DropdownButton(
                  backgroundColor: Colors.transparent,
                  foregroundColor: foregroundColor,
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Separate the main icon and dropdown section
      Widget mainIconButton = WidgetStateBuilder(
        disabled: _disabled,
        onTap: _onTap ?? () {},
        builder: (Set<WidgetState> states) {
          Set<WidgetState> updatedStates = <WidgetState>{
            if (_selected) WidgetState.selected,
            ...states,
          };

          Color backgroundColor = _resolveBackgroundColor(updatedStates);
          Color foregroundColor = _resolveForegroundColor(updatedStates);

          return DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: _hasDropdown
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      bottomLeft: Radius.circular(3),
                    )
                  : BorderRadius.circular(3),
            ),
            child: Center(
              child: AssetIcon(_icon, size: 14, color: foregroundColor),
            ),
          );
        },
      );

      Widget? dropdownSection;
      if (_hasDropdown && _onDropdownTap != null) {
        dropdownSection = WidgetStateBuilder(
          disabled: _disabled,
          onTap: _onDropdownTap,
          builder: (Set<WidgetState> states) {
            Set<WidgetState> updatedStates = <WidgetState>{
              if (_opened) WidgetState.pressed,
              ...states,
            };

            Color backgroundColor = _resolveDropdownBackgroundColor(updatedStates);
            Color foregroundColor = _resolveDropdownForegroundColor(updatedStates);

            return _DropdownButton(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
            );
          },
        );
      } else if (_hasDropdown) {
        // For completeness, handle the case where _onDropdownTap is null
        dropdownSection = _DropdownButton(
          backgroundColor: Colors.transparent,
          foregroundColor: _resolveForegroundColor(<WidgetState>{}),
        );
      }

      return Container(
        width: _size.width,
        height: _size.height,
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: mainIconButton),
            if (dropdownSection != null) dropdownSection,
          ],
        ),
      );
    }
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xffD8E2F9);
    } else if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return const Color(0xffeef2f9);
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF041E49);
    } else {
      return const Color(0xFF333333);
    }
  }

  Color _resolveDropdownBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffDDDFE4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffE4E7EA);
    } else {
      return const Color(0xffeef2f9);
    }
  }

  Color _resolveDropdownForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}

class GoogToolbarButton extends StatelessWidget {
  const GoogToolbarButton({
    required this.child,
    double? width,
    double? height,
    super.key,
  })  : width = width ?? 24,
        height = height ?? 24;

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GoogIconTheme(
      data: _iconThemeData,
      child: child,
    );
  }

  GoogIconThemeData get _iconThemeData {
    return GoogIconThemeData(
      size: WidgetStateProperty.all(width),
      color: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF041E49);
        } else {
          return const Color(0xFF333333);
        }
      }),
    );
  }
}

class _DropdownButton extends StatelessWidget {
  const _DropdownButton({
    required Color backgroundColor,
    required Color foregroundColor,
  })  : _backgroundColor = backgroundColor,
        _foregroundColor = foregroundColor;

  final Color _backgroundColor;
  final Color _foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 13,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomRight: Radius.circular(3),
        ),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 1),
          AssetIcon(
            SheetIcons.docs_icon_arrow_dropdown,
            width: 8,
            height: 4,
            color: _foregroundColor,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
