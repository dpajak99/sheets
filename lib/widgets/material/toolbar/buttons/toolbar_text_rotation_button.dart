import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/goog_palette.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_combo_button.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarTextRotationButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarTextRotationButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TextRotation value;
  final ValueChanged<TextRotation> onChanged;

  @override
  Size get size => const Size(39, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextRotation>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<TextRotation>>.has('onChanged', onChanged));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarTextRotationButtonState();
}

class _ToolbarTextRotationButtonState extends State<ToolbarTextRotationButton> {
  late final DropdownButtonController _dropdownController;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _dropdownController = DropdownButtonController();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        AssetIconData icon = _resolveIcon(widget.value);
        return GoogToolbarMenuButton(margin: widget.margin, child: GoogIcon(icon));
      },
      popupBuilder: (BuildContext context) {
        return GoogPalette(
          gap: 1,
          trailing: GoogToolbarComboButton(
            size: const Size(61, 26),
            margin: widget.margin,
            controller: _controller,
            focusNode: _focusNode,
            decoration: GoogToolbarComboButtonInputDecoration(
              hasDropdown: true,
              textAlign: TextAlign.left,
              hintText: '0°',
            ),
            style: GoogToolbarComboButtonStyle.defaultStyle().copyWith(
              backgroundColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          children: TextRotation.values.map((TextRotation textRotation) {
            AssetIconData icon = _resolveIcon(textRotation);
            return _TextRotationOption(
                selected: widget.value == textRotation,
                icon: icon,
                onPressed: () {
                  widget.onChanged(textRotation);
                  _dropdownController.close();
                });
          }).toList(),
        );
      },
    );
  }

  AssetIconData _resolveIcon(TextRotation textRotation) {
    return switch (textRotation) {
      TextRotation.none => SheetIcons.docs_icon_text_rotation_none_20,
      TextRotation.angleUp => SheetIcons.docs_icon_text_rotation_angleup_20,
      TextRotation.angleDown => SheetIcons.docs_icon_text_rotation_angledown_20,
      TextRotation.vertical => SheetIcons.docs_icon_text_rotation_vertical_20,
      TextRotation.up => SheetIcons.docs_icon_text_rotation_up_20,
      TextRotation.down => SheetIcons.docs_icon_text_rotation_down_20,
      (_) => SheetIcons.docs_icon_editors_ia_right_angle,
    };
  }
}

class _TextRotationOption extends StatelessWidget {
  const _TextRotationOption({
    required bool selected,
    required AssetIconData icon,
    required VoidCallback onPressed,
  })  : _selected = selected,
        _icon = icon,
        _onPressed = onPressed;

  final bool _selected;
  final AssetIconData _icon;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return GoogPaletteItem(selected: _selected, icon: _icon, onPressed: _onPressed);
  }
}
