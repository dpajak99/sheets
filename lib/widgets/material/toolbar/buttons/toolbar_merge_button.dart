import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_button.dart';
import 'package:sheets/widgets/material/generic/dropdown/dropdown_list_menu.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/googl_toolbar_menu_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarMergeButton extends StatefulWidget implements StaticSizeWidget {
  const ToolbarMergeButton({
    required this.merged,
    required this.canMerge,
    required this.canMergeVertically,
    required this.canMergeHorizontally,
    required this.canSplit,
    required this.onMerge,
    required this.onMergeVertically,
    required this.onMergeHorizontally,
    required this.onSplit,
    super.key,
  });

  final bool merged;
  final bool canMerge;
  final bool canMergeVertically;
  final bool canMergeHorizontally;
  final bool canSplit;
  final VoidCallback onMerge;
  final VoidCallback onMergeVertically;
  final VoidCallback onMergeHorizontally;
  final VoidCallback onSplit;

  @override
  Size get size => const Size(42, 30);

  @override
  EdgeInsets get margin => const EdgeInsets.symmetric(horizontal: 1);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('merged', merged));
    properties.add(DiagnosticsProperty<bool>('canMerge', canMerge));
    properties.add(DiagnosticsProperty<bool>('canMergeVertically', canMergeVertically));
    properties.add(DiagnosticsProperty<bool>('canMergeHorizontally', canMergeHorizontally));
    properties.add(DiagnosticsProperty<bool>('canSplit', canSplit));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onMerge', onMerge));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onMergeVertically', onMergeVertically));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onMergeHorizontally', onMergeHorizontally));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSplit', onSplit));
  }

  @override
  State<StatefulWidget> createState() => _ToolbarMergeButtonState();
}

class _ToolbarMergeButtonState extends State<ToolbarMergeButton> {
  late final DropdownButtonController _dropdownController;

  @override
  void initState() {
    super.initState();
    _dropdownController = DropdownButtonController();
  }

  @override
  Widget build(BuildContext context) {
    return SheetDropdownButton(
      activateDropdownBehavior: ActivateDropdownBehavior.manual,
      controller: _dropdownController,
      buttonBuilder: (BuildContext context, bool isOpen) {
        return GoogToolbarMenuButton(
          disabled: !(widget.canMerge || widget.canSplit),
          margin: widget.margin,
          selected: widget.merged,
          child: const GoogIcon(SheetIcons.docs_icon_cell_merge_20),
          onDropdownTap: () {
            _dropdownController.toggle();
          },
          onTap: () {
            if (widget.canSplit) {
              widget.onSplit();
            } else {
              widget.onMerge();
            }
          },
        );
      },
      popupBuilder: (BuildContext context) {
        return DropdownListMenu(
          width: 262,
          children: <Widget>[
            DropdownListMenuItem(
              disabled: !widget.canMerge,
              iconPlaceholderVisible: false,
              label: 'Scal wszystkie',
              onPressed: widget.onMerge,
            ),
            DropdownListMenuItem(
              disabled: !widget.canMergeVertically,
              iconPlaceholderVisible: false,
              label: 'Scal w pionie',
              onPressed: widget.onMergeVertically,
            ),
            DropdownListMenuItem(
              disabled: !widget.canMergeHorizontally,
              iconPlaceholderVisible: false,
              label: 'Scal w poziomie',
              onPressed: widget.onMergeHorizontally,
            ),
            DropdownListMenuItem(
              disabled: !widget.canSplit,
              iconPlaceholderVisible: false,
              label: 'Rozdziel',
              onPressed: widget.onSplit,
            ),
          ],
        );
      },
    );
  }
}
