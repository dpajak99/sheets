import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_button.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_buttons_section.dart';
import 'package:sheets/widgets/sheet_text_field.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class SheetSectionToolbar extends StatefulWidget {
  const SheetSectionToolbar({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _SheetSectionToolbarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _SheetSectionToolbarState extends State<SheetSectionToolbar> {
  @override
  Widget build(BuildContext context) {
    return SheetTheme(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: const BoxDecoration(
          color: Color(0xfff9fbfd),
        ),
        child: Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xffeef2f9),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ToolbarButtonsSectionWrapper(
                  sections: <ToolbarButtonsSection>[
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarSearchbar(),
                      ],
                      smallButtons: <ToolbarItem>[
                        ToolbarButton.large(SheetIcons.search),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.icon(SheetIcons.undo),
                        ToolbarButton.icon(SheetIcons.redo),
                        ToolbarButton.icon(SheetIcons.print),
                        ToolbarButton.icon(SheetIcons.paint),
                        ToolbarTextDropdownButton(value: '100%', width: 75),
                        ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.text('zloty'),
                        ToolbarButton.icon(SheetIcons.percentage),
                        ToolbarButton.icon(SheetIcons.decimal_decrease),
                        ToolbarButton.icon(SheetIcons.decimal_increase),
                        ToolbarButton.text('123'),
                        ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarTextDropdownButton(value: 'Default', width: 97),
                        ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.iconSmall(SheetIcons.add),
                        ToolbarTextField(value: '10'),
                        ToolbarButton.iconSmall(SheetIcons.remove),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.icon(
                          SheetIcons.format_bold,
                          onTap: () {
                            widget.sheetController.formatSelection(TextStyleUpdateRequest(
                              fontWeight: FontWeight.bold,
                            ));
                          },
                        ),
                        const ToolbarButton.icon(SheetIcons.format_italic),
                        const ToolbarButton.icon(SheetIcons.strikethrough),
                        const ToolbarColorPickerButton(icon: SheetIcons.format_color_text, color: Colors.red),
                        const ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarColorPickerButton(icon: SheetIcons.format_color_fill, color: Colors.red),
                        ToolbarButton.icon(SheetIcons.border_all),
                        ToolbarDropdownButtonSeparated(icon: SheetIcons.cell_merge),
                        ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarDropdownButton(icon: SheetIcons.format_align_left),
                        ToolbarDropdownButton(icon: SheetIcons.vertical_align_bottom),
                        ToolbarDropdownButton(icon: SheetIcons.format_text_overflow),
                        ToolbarDropdownButton(icon: SheetIcons.text_rotation_none),
                        ToolbarDivider(),
                      ],
                    ),
                    const ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.icon(SheetIcons.link),
                        ToolbarButton.icon(SheetIcons.add_comment),
                        ToolbarButton.icon(SheetIcons.insert_chart),
                        ToolbarButton.icon(SheetIcons.filter_alt),
                        ToolbarDropdownButton(icon: SheetIcons.table_view),
                        ToolbarButton.icon(SheetIcons.functions),
                      ],
                    ),
                  ],
                ),
              ),
              const ToolbarButton.icon(SheetIcons.arrow_up),
            ],
          ),
        ),
      ),
    );
  }
}
