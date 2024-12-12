import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
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
          const AssetIcon(SheetIcons.logo, width: 26, height: 35),
          const SizedBox(width: 9),
          Column(
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
                  AppBarIconButton(icon: SheetIcons.star, onPressed: () {}),
                  AppBarIconButton(icon: SheetIcons.move, onPressed: () {}),
                  AppBarIconButton(icon: SheetIcons.cloud_no_sync, onPressed: () {}),
                ],
              ),
              Row(
                children: <Widget>[
                  AppBarButton(label: 'Plik', onPressed: () {}),
                  AppBarButton(label: 'Edytuj', onPressed: () {}),
                  AppBarButton(label: 'Widok', onPressed: () {}),
                  AppBarButton(label: 'Wstaw', onPressed: () {}),
                  AppBarButton(label: 'Formatuj', onPressed: () {}),
                  AppBarButton(label: 'Dane', onPressed: () {}),
                  AppBarButton(label: 'Narzędzia', onPressed: () {}),
                  AppBarButton(label: 'Rozszerzenia', onPressed: () {}),
                  AppBarButton(label: 'Pomoc', onPressed: () {}),
                ],
              ),
            ],
          ),
          const Spacer(),
          const AssetIcon(SheetIcons.history, color: Color(0xff444746)),
          const AssetIcon(SheetIcons.camera, color: Color(0xff444746)),
          const AssetIcon(SheetIcons.comment, color: Color(0xff444746)),
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

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    required String label,
    required void Function() onPressed,
    super.key,
  })  : _onPressed = onPressed,
        _label = label;

  final String _label;
  final VoidCallback _onPressed;

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
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              _label,
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
  const AppBarIconButton({
    required AssetIconData icon,
    required void Function() onPressed,
    super.key,
  })  : _onPressed = onPressed,
        _icon = icon;

  final AssetIconData _icon;
  final VoidCallback _onPressed;

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
          width: 24,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AssetIcon(
              _icon,
              size: 16,
              color: foregroundColor,
            ),
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
