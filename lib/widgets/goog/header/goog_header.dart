import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/header/goog_data_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_edit_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_file_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_format_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_help_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_insert_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_tools_control_menu.dart';
import 'package:sheets/widgets/goog/menu/header/goog_view_control_menu.dart';
import 'package:sheets/widgets/popup/dropdown_button.dart';
import 'package:sheets/widgets/popup/sheet_popup.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class GoogHeader extends StatefulWidget {
  const GoogHeader({super.key});

  @override
  State<StatefulWidget> createState() => _GoogHeaderState();
}

class _GoogHeaderState extends State<GoogHeader> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController(text: 'Arkusz kalkulacyjny bez tytułu');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 5),
      decoration: const BoxDecoration(
        color: Color(0xfff9fbfd),
      ),
      child: Row(
        children: <Widget>[
          const AssetIcon(SheetIcons.docs_icon_logo_sheets_36, width: 26, height: 35),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: IntrinsicWidth(
                        child: GoogHeaderTextField(
                          focusNode: _focusNode,
                          controller: _controller,
                        ),
                      ),
                    ),
                    GoogTitlebarBadge(child: const GoogIcon(SheetIcons.docs_icon_star_border_20), onPressed: () {}),
                    GoogTitlebarBadge(child: const GoogIcon(SheetIcons.docs_icon_folder_move_20), onPressed: () {}),
                    GoogTitlebarBadge(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      onPressed: () {},
                      child: const GoogIcon(SheetIcons.docs_icon_cloud_check_20),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    GoogHeaderControlButton(child: const GoogText('Plik'), popupBuilder: (_) => const GoogFileControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Edytuj'), popupBuilder: (_) => const GoogEditControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Widok'), popupBuilder: (_) => const GoogViewControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Wstaw'), popupBuilder: (_) => const GoogInsertControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Formatuj'), popupBuilder: (_) => const GoogFormatControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Dane'), popupBuilder: (_) => const GoogDataControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Narzędzia'), popupBuilder: (_) => const GoogToolsControlMenu()),
                    GoogHeaderControlButton(child: const GoogText('Pomoc'), popupBuilder: (_) => const GoogHelpControlMenu()),
                  ],
                ),
              ],
            ),
          ),
          GoogHeaderCircleButton(child: const GoogIcon(SheetIcons.docs_history_24), onPressed: () {}),
          GoogHeaderCircleButton(child: const GoogIcon(SheetIcons.docs_icon_comment_topbar_24), onPressed: () {}),
          GoogHeaderCircleButton(onPressed: () {}, hasDropdown: true, child: const GoogIcon(SheetIcons.docs_icon_meet_24)),
          GoogTitlebarShareButton(),
          const SizedBox(width: 12),
          Image.asset(
            'assets/avatar.png',
            package: 'sheets',
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}

class GoogHeaderTextField extends StatelessWidget {
  const GoogHeaderTextField({
    required FocusNode focusNode,
    required TextEditingController controller,
    super.key,
  })  : _focusNode = focusNode,
        _controller = controller;

  final FocusNode _focusNode;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      focusNode: _focusNode,
      builder: (Set<WidgetState> states) {
        Color borderColor = Colors.transparent;
        double borderWidth = 1;
        if (states.contains(WidgetState.focused)) {
          borderColor = const Color(0xff2456cb);
          borderWidth = 2;
        } else if (states.contains(WidgetState.hovered)) {
          borderColor = const Color(0xff757775);
        }

        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor, width: borderWidth, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: EditableText(
            focusNode: _focusNode,
            controller: _controller,
            style: const TextStyle(
              fontSize: 18,
              height: 1,
              fontFamily: 'Google Sans',
              package: 'sheets',
              color: Color(0xff000000),
            ),
            cursorColor: Colors.black,
            backgroundCursorColor: Colors.black,
          ),
        );
      },
    );
  }
}

class GoogHeaderControlButton extends StatefulWidget {
  GoogHeaderControlButton({
    required this.child,
    required this.popupBuilder,
    GoogTitlebarButtonStyle? style,
    super.key,
  }) : style = style ?? GoogTitlebarButtonStyle.fromDefaults();

  final Widget child;
  final PopupBuilder popupBuilder;
  final GoogTitlebarButtonStyle style;

  @override
  State<StatefulWidget> createState() => _GoogHeaderControlButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<PopupBuilder>.has('popupBuilder', popupBuilder));
    properties.add(DiagnosticsProperty<GoogTitlebarButtonStyle>('style', style));
  }
}

class _GoogHeaderControlButtonState extends State<GoogHeaderControlButton> {
  final DropdownButtonController _controller = DropdownButtonController();

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _controller,
      popupBuilder: widget.popupBuilder,
      activateDropdownBehavior: ActivateDropdownBehavior.manual,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return WidgetStateBuilder(
          onTap: _controller.toggle,
          cursor: SystemMouseCursors.click,
          builder: (Set<WidgetState> states) {
            Set<WidgetState> updatedStates = <WidgetState>{
              if (isOpen) WidgetState.pressed,
              ...states,
            };
            Color? backgroundColor = widget.style.backgroundColor.resolve(updatedStates);
            Color? foregroundColor = widget.style.foregroundColor.resolve(updatedStates);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: GoogTextTheme(
                  fontFamily: 'GoogleSans',
                  package: 'sheets',
                  fontSize: 14,
                  height: 1.3,
                  color: foregroundColor,
                  textAlign: TextAlign.center,
                  child: widget.child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class GoogTitlebarBadge extends StatelessWidget {
  GoogTitlebarBadge({
    required Widget child,
    required void Function() onPressed,
    double? size,
    EdgeInsets? margin,
    EdgeInsets? padding,
    GoogTitlebarButtonStyle? style,
    super.key,
  })  : _onPressed = onPressed,
        _child = child,
        _size = size ?? 28,
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 2),
        _padding = padding ?? const EdgeInsets.all(6),
        _style = style ?? GoogTitlebarButtonStyle.fromDefaults();

  final Widget _child;
  final VoidCallback _onPressed;
  final double _size;
  final EdgeInsets _margin;
  final EdgeInsets _padding;
  final GoogTitlebarButtonStyle _style;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          ...states,
        };
        Color? backgroundColor = _style.backgroundColor.resolve(updatedStates);
        Color? foregroundColor = _style.foregroundColor.resolve(updatedStates);

        return Container(
          width: _size,
          height: _size,
          padding: _padding,
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: GoogIconTheme(
            color: foregroundColor,
            child: _child,
          ),
        );
      },
    );
  }
}

class GoogHeaderCircleButton extends StatelessWidget {
  GoogHeaderCircleButton({
    required Widget child,
    required void Function() onPressed,
    bool? hasDropdown,
    double? size,
    EdgeInsets? margin,
    GoogTitlebarButtonStyle? style,
    super.key,
  })  : _onPressed = onPressed,
        _child = child,
        _hasDropdown = hasDropdown ?? false,
        _size = size ?? 42,
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 4),
        _style = style ?? GoogTitlebarButtonStyle.fromDefaults();

  final Widget _child;
  final VoidCallback _onPressed;
  final bool _hasDropdown;
  final double _size;
  final EdgeInsets _margin;
  final GoogTitlebarButtonStyle _style;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          ...states,
        };
        Color? backgroundColor = _style.backgroundColor.resolve(updatedStates);
        Color? foregroundColor = _style.foregroundColor.resolve(updatedStates);

        return Container(
          height: _size,
          padding: _hasDropdown ? const EdgeInsets.symmetric(horizontal: 15, vertical: 12) : const EdgeInsets.all(11),
          margin: _margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: _hasDropdown ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: _hasDropdown ? BorderRadius.circular(45) : null,
          ),
          child: Row(
            children: <Widget>[
              GoogIconTheme(
                color: foregroundColor,
                child: _child,
              ),
              if (_hasDropdown) ...<Widget>[
                const SizedBox(width: 10),
                AssetIcon(
                  SheetIcons.docs_icon_arrow_dropdown,
                  width: 8,
                  height: 4,
                  color: foregroundColor,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class GoogTitlebarShareButton extends StatelessWidget {
  GoogTitlebarShareButton({
    GoogTitlebarShareButtonStyle? style,
    super.key,
  }) : _style = style ?? GoogTitlebarShareButtonStyle.fromDefaults();

  final GoogTitlebarShareButtonStyle _style;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: SizedBox(
        width: 159,
        height: 40,
        child: Row(
          children: <Widget>[
            WidgetStateBuilder(
              onTap: () {},
              cursor: SystemMouseCursors.click,
              builder: (Set<WidgetState> states) {
                Color? backgroundColor = _style.backgroundColor.resolve(states);
                Color? foregroundColor = _style.foregroundColor.resolve(states);

                return Container(
                  color: backgroundColor,
                  width: 125,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AssetIcon(
                        SheetIcons.scb_lock_s900,
                        width: 12,
                        height: 17,
                        color: foregroundColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Udostępnij',
                        style: TextStyle(
                          fontFamily: 'Google Sans',
                          package: 'sheets',
                          fontSize: 14,
                          height: 1.3,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 1, height: double.infinity),
            WidgetStateBuilder(
              onTap: () {},
              cursor: SystemMouseCursors.click,
              builder: (Set<WidgetState> states) {
                Color? backgroundColor = _style.backgroundColor.resolve(states);
                Color? foregroundColor = _style.foregroundColor.resolve(states);

                return Container(
                  width: 33,
                  height: double.infinity,
                  padding: const EdgeInsets.only(right: 1, bottom: 2),
                  color: backgroundColor,
                  child: Center(
                    child: AssetIcon(
                      SheetIcons.docs_icon_arrow_dropdown,
                      width: 8,
                      height: 4,
                      color: foregroundColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoogTitlebarButtonStyle {
  GoogTitlebarButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory GoogTitlebarButtonStyle.fromDefaults() {
    return GoogTitlebarButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xffdfe3e4);
        } else if (states.contains(WidgetState.hovered)) {
          return const Color(0xffe9ebee);
        } else {
          return Colors.transparent;
        }
      }),
      foregroundColor: WidgetStateProperty.all(const Color(0xFF444746)),
    );
  }

  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
}

class GoogTitlebarShareButtonStyle {
  GoogTitlebarShareButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory GoogTitlebarShareButtonStyle.fromDefaults() {
    return GoogTitlebarShareButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xffbed5eb);
        } else {
          return const Color(0xffc9e6fd);
        }
      }),
      foregroundColor: WidgetStateProperty.all(const Color(0xff071c34)),
    );
  }

  final WidgetStateProperty<Color> backgroundColor;
  final WidgetStateProperty<Color> foregroundColor;
}
