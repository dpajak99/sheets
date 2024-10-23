import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_button.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_buttons_section.dart';
import 'package:sheets/widgets/sheet_theme.dart';

class SheetSectionToolbar extends StatefulWidget {
  const SheetSectionToolbar({super.key});

  @override
  State<StatefulWidget> createState() => _SheetSectionToolbarState();
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
          child: const Row(
            children: <Widget>[
              Expanded(
                child: ToolbarButtonsSectionWrapper(
                  sections: <ToolbarButtonsSection>[
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarSearchbar(),
                      ],
                      smallButtons: <ToolbarItem>[
                        ToolbarButton.large(SheetIcons.search),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.icon(SheetIcons.undo),
                        ToolbarButton.icon(SheetIcons.redo),
                        ToolbarButton.icon(SheetIcons.print),
                        ToolbarButton.icon(SheetIcons.paint),
                        ToolbarTextDropdownButton(value: '100%', width: 75),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.text('zloty'),
                        ToolbarButton.icon(SheetIcons.percentage),
                        ToolbarButton.icon(SheetIcons.decimal_decrease),
                        ToolbarButton.icon(SheetIcons.decimal_increase),
                        ToolbarButton.text('123'),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarTextDropdownButton(value: 'Default', width: 97),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.iconSmall(SheetIcons.add),
                        ToolbarTextField(value: '10'),
                        ToolbarButton.iconSmall(SheetIcons.remove),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarButton.icon(SheetIcons.format_bold),
                        ToolbarButton.icon(SheetIcons.format_italic),
                        ToolbarButton.icon(SheetIcons.strikethrough),
                        ToolbarColorPickerButton(icon: SheetIcons.format_color_text, color: Colors.red),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarColorPickerButton(icon: SheetIcons.format_color_fill, color: Colors.red),
                        ToolbarButton.icon(SheetIcons.border_all),
                        ToolbarDropdownButtonSeparated(icon: SheetIcons.cell_merge),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
                      buttons: <ToolbarItem>[
                        ToolbarDropdownButton(icon: SheetIcons.format_align_left),
                        ToolbarDropdownButton(icon: SheetIcons.vertical_align_bottom),
                        ToolbarDropdownButton(icon: SheetIcons.format_text_overflow),
                        ToolbarDropdownButton(icon: SheetIcons.text_rotation_none),
                        ToolbarDivider(),
                      ],
                    ),
                    ToolbarButtonsSection(
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
              ToolbarButton.icon(SheetIcons.arrow_up),
            ],
          ),
        ),
      ),
    );
  }
}
