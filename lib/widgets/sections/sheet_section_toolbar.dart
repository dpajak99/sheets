import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/cell_properties.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/values/actions/cell_style_format_action.dart';
import 'package:sheets/core/values/actions/text_style_format_actions.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_color_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_divider.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_font_family_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_font_size_textfield.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_searchbar.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_align_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_format_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_overflow_button.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_text_vertical_align_button.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_buttons_section.dart';
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
          child: ListenableBuilder(
            listenable: Listenable.merge(<Listenable?>[
              widget.sheetController.activeCellNotifier,
              widget.sheetController.properties,
              widget.sheetController.selection,
            ]),
            builder: (BuildContext context, _) {
              return ListenableBuilder(
                listenable: Listenable.merge(<Listenable?>[
                  widget.sheetController.activeCellNotifier.value?.controller,
                ]),
                builder: (BuildContext context, _) {
                  SelectionStyle selectionStyle = widget.sheetController.getSelectionStyle();

                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: ToolbarButtonsSectionWrapper(
                          sections: <ToolbarButtonsSection>[
                            const ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarSearchbar.expanded(),
                              ],
                              smallButtons: <Widget>[
                                MaterialToolbarSearchbar.collapsed(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarIconButton(icon: SheetIcons.undo, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.redo, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.print, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.paint, onTap: () {}),
                                // ToolbarTextDropdownButton(value: '100%', width: 75),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarTextButton(text: 'zloty', onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.percentage, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.decimal_decrease, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.decimal_increase, onTap: () {}),
                                const MaterialToolbarFormatButton(),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarFontFamilyButton(
                                  selectedFontFamily: 'Default',
                                  onChanged: (String value) {
                                    widget.sheetController.formatSelection(UpdateFontFamilyAction(selectionStyle, value));
                                  },
                                ),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarIconButton.small(
                                  icon: SheetIcons.remove,
                                  onTap: () {
                                    widget.sheetController.formatSelection(DecreaseFontSizeAction(selectionStyle));
                                  },
                                ),
                                MaterialToolbarFontSizeTextfield(
                                  selectedFontSize: selectionStyle.fontSize ?? 0,
                                  onChanged: (double value) {},
                                ),
                                MaterialToolbarIconButton.small(
                                  icon: SheetIcons.add,
                                  onTap: () {
                                    widget.sheetController.formatSelection(IncreaseFontSizeAction(selectionStyle));
                                  },
                                ),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarIconButton(
                                  icon: SheetIcons.format_bold,
                                  active: selectionStyle.fontWeight == FontWeight.bold,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(UpdateFontWeightAction(selectionStyle, FontWeight.bold));
                                  },
                                ),
                                MaterialToolbarIconButton(
                                  icon: SheetIcons.format_italic,
                                  active: selectionStyle.fontStyle == FontStyle.italic,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(UpdateFontStyleAction(selectionStyle, FontStyle.italic));
                                  },
                                ),
                                MaterialToolbarIconButton(
                                  icon: SheetIcons.strikethrough,
                                  active: selectionStyle.decoration == TextDecoration.lineThrough,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(UpdateTextDecorationAction(selectionStyle, TextDecoration.lineThrough));
                                  },
                                ),
                                MaterialToolbarColorButton(
                                  icon: SheetIcons.format_color_text,
                                  color: selectionStyle.color ?? defaultTextStyle.color ?? Colors.black,
                                  onSelected: (Color color) {
                                    widget.sheetController.formatSelection(UpdateFontColorAction(selectionStyle, color));
                                  },
                                ),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarColorButton(
                                  icon: SheetIcons.format_color_fill,
                                  color: selectionStyle.backgroundColor ?? defaultTextStyle.backgroundColor ?? Colors.white,
                                  onSelected: (Color color) {
                                    widget.sheetController.formatSelection(UpdateBackgroundColorAction(color));
                                  },
                                ),
                                MaterialToolbarIconButton(icon: SheetIcons.border_all, onTap: () {}),
                                MaterialToolbarIconButton.withDropdown(icon: SheetIcons.cell_merge, onTap: () {}),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialTextAlignButton(
                                  selectedTextAlign: selectionStyle.textAlignHorizontal,
                                  onChanged: (TextAlign value) {
                                    widget.sheetController.formatSelection(UpdateHorizontalTextAlignAction(value));
                                  },
                                ),
                                MaterialTextVerticalAlignButton(
                                  selectedTextAlign: selectionStyle.textAlignVertical,
                                  onChanged: (TextVerticalAlign value) {
                                    widget.sheetController.formatSelection(UpdateVerticalTextAlignAction(value));
                                  },
                                ),
                                MaterialTextOverflowButton(
                                  selectedTextOverflow: TextOverflowBehavior.overflow,
                                  onChanged: (TextOverflowBehavior value) {
                                    // widget.sheetController.formatSelection(UpdateVerticalAlignAction(selectionStyle, value));
                                  },
                                ),
                                MaterialToolbarIconButton.withDropdown(icon: SheetIcons.text_rotation_none, onTap: () {}),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarIconButton(icon: SheetIcons.link, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.add_comment, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.insert_chart, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.filter_alt, onTap: () {}),
                                MaterialToolbarIconButton.withDropdown(icon: SheetIcons.table_view, onTap: () {}),
                                MaterialToolbarIconButton(icon: SheetIcons.functions, onTap: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                      MaterialToolbarIconButton(icon: SheetIcons.arrow_up, onTap: () {}),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
