import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/popup/sheet_popup.dart';
import 'package:sheets/widgets/material/menu/app_bar_file_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_data_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_edit_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_extensions_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_format_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_help_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_insert_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_tools_context_menu.dart';
import 'package:sheets/widgets/material/menu/app_view_context_menu.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

class SheetAppBar extends StatefulWidget {
  const SheetAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _SheetAppBarState();
}

class _SheetAppBarState extends State<SheetAppBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController(text: 'Arkusz kalkulacyjny bez tytułu');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
      decoration: const BoxDecoration(
        color: Color(0xfff9fbfd),
      ),
      child: Row(
        children: <Widget>[
          // TODO(Dominik): Missing icon
          const AssetIcon(SheetIcons.docs_icon_align_center, width: 26, height: 35),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IntrinsicWidth(
                      child: AppBarTextField(
                        focusNode: _focusNode,
                        controller: _controller,
                      ),
                    ),
                    AppBarIconButton.small(icon: SheetIcons.docs_icon_star_border_20, onPressed: () {}),
                    // TODO(Dominik): Missing icon
                    AppBarIconButton.small(icon: SheetIcons.docs_icon_folder_move, onPressed: () {}),
                    AppBarIconButton.small(icon: SheetIcons.docs_icon_cloud_check_20, onPressed: () {}),
                  ],
                ),
                Row(
                  children: <Widget>[
                    AppBarButton(label: 'Plik', popupBuilder: (_) => const AppBarFileContextMenu()),
                    AppBarButton(label: 'Edytuj', popupBuilder: (_) => const AppBarEditContextMenu()),
                    AppBarButton(label: 'Widok', popupBuilder: (_) => const AppBarViewContextMenu()),
                    AppBarButton(label: 'Wstaw', popupBuilder: (_) => const AppBarInsertContextMenu()),
                    AppBarButton(label: 'Formatuj', popupBuilder: (_) => const AppBarFormatContextMenu()),
                    AppBarButton(label: 'Dane', popupBuilder: (_) => const AppBarDataContextMenu()),
                    AppBarButton(label: 'Narzędzia', popupBuilder: (_) => const AppBarToolsContextMenu()),
                    AppBarButton(label: 'Rozszerzenia', popupBuilder: (_) => const AppBarExtensionsContextMenu()),
                    AppBarButton(label: 'Pomoc', popupBuilder: (_) => const AppBarHelpContextMenu()),
                  ],
                ),
              ],
            ),
          ),
          AppBarIconButton.large(icon: SheetIcons.docs_history_24, onPressed: () {}),
          AppBarIconButton.large(icon: SheetIcons.docs_icon_comment_topbar_24, onPressed: () {}),
          AppBarIconButton.large(icon: SheetIcons.docs_icon_meet_24, onPressed: () {}, hasDropdown: true),
          const AppBarShareButton(),
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

class AppBarTextField extends StatelessWidget {
  const AppBarTextField({
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

class AppBarButton extends StatefulWidget {
  const AppBarButton({
    required this.label,
    required this.popupBuilder,
    super.key,
  });

  final String label;
  final PopupBuilder popupBuilder;

  @override
  State<StatefulWidget> createState() => _AppBarButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(ObjectFlagProperty<PopupBuilder>.has('popupBuilder', popupBuilder));
  }
}

class _AppBarButtonState extends State<AppBarButton> {
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
            Color? backgroundColor = _resolveBackgroundColor(updatedStates);
            Color? foregroundColor = _resolveForegroundColor(updatedStates);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    package: 'sheets',
                    fontSize: 14,
                    height: 1.3,
                    color: foregroundColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffdfe3e4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffe9ebee);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton.small({
    required AssetIconData icon,
    required void Function() onPressed,
    bool? hasDropdown,
    super.key,
  })  : _onPressed = onPressed,
        _icon = icon,
        _height = 24,
        _width = 24,
        _iconSize = 16,
        _margin = 2,
        _hasDropdown = hasDropdown ?? false;

  const AppBarIconButton.large({
    required AssetIconData icon,
    required void Function() onPressed,
    bool? hasDropdown,
    super.key,
  })  : _onPressed = onPressed,
        _icon = icon,
        _height = 42,
        _width = (hasDropdown ?? false) ? 68 : 42,
        _iconSize = 20,
        _margin = 4,
        _hasDropdown = hasDropdown ?? false;

  final AssetIconData _icon;
  final VoidCallback _onPressed;
  final double _height;
  final double _width;
  final double _iconSize;
  final double _margin;
  final bool _hasDropdown;

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onPressed,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Set<WidgetState> updatedStates = <WidgetState>{
          ...states,
        };
        Color? backgroundColor = _resolveBackgroundColor(updatedStates);
        Color? foregroundColor = _resolveForegroundColor(updatedStates);

        return Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.symmetric(horizontal: _margin),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: _hasDropdown ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: _hasDropdown ? BorderRadius.circular(45) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AssetIcon(
                _icon,
                size: _iconSize,
                color: foregroundColor,
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

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return const Color(0xffdfe3e4);
    } else if (states.contains(WidgetState.hovered)) {
      return const Color(0xffe9ebee);
    } else {
      return Colors.transparent;
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xFF444746);
  }
}

class AppBarShareButton extends StatelessWidget {
  const AppBarShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: SizedBox(
        width: 159,
        height: 40,
        child: Row(
          children: [
            WidgetStateBuilder(
              onTap: () {},
              cursor: SystemMouseCursors.click,
              builder: (Set<WidgetState> states) {
                Set<WidgetState> updatedStates = <WidgetState>{
                  ...states,
                };
                Color? backgroundColor = _resolveBackgroundColor(updatedStates);
                Color? foregroundColor = _resolveForegroundColor(updatedStates);

                return Container(
                  color: backgroundColor,
                  width: 125,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 16, right: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AssetIcon(
                        // TODO(Domini): Missing icon
                        SheetIcons.docs_icon_align_justify_20,
                        size: 16,
                        color: foregroundColor,
                      ),
                      const SizedBox(width: 8),
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
                Set<WidgetState> updatedStates = <WidgetState>{
                  ...states,
                };
                Color? backgroundColor = _resolveBackgroundColor(updatedStates);
                Color? foregroundColor = _resolveForegroundColor(updatedStates);

                return Container(
                  width: 33,
                  height: double.infinity,
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

  Color _resolveBackgroundColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xffbed5eb);
    } else {
      return const Color(0xffc9e6fd);
    }
  }

  Color _resolveForegroundColor(Set<WidgetState> states) {
    return const Color(0xff071c34);
  }
}
