import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/text_vertical_align.dart';
import 'package:sheets/widgets/material/toolbar_items/material_toolbar_border_button.dart';
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
              widget.sheetController.dataManager,
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
                                MaterialToolbarTextButton(
                                    text: NumberFormat.currency().currencySymbol,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: SheetNumberFormat.currency()));
                                    }),
                                MaterialToolbarIconButton(
                                    icon: SheetIcons.percentage,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: SheetNumberFormat.percentPattern()));
                                    }),
                                MaterialToolbarIconButton(
                                    icon: SheetIcons.decimal_decrease,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: selectionStyle.valueFormat.decreaseDecimal()));
                                    }),
                                MaterialToolbarIconButton(
                                    icon: SheetIcons.decimal_increase,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: selectionStyle.valueFormat.increaseDecimal()));
                                    }),
                                MaterialToolbarFormatButton(
                                  onChanged: (SheetValueFormat value) {
                                    widget.sheetController.formatSelection(SetValueFormatIntent(format: value));
                                  },
                                ),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialToolbarFontFamilyButton(
                                  selectedFontFamily: 'Default',
                                  onChanged: (String fontFamily) {
                                    widget.sheetController.formatSelection(SetFontFamilyIntent(fontFamily: fontFamily));
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
                                    widget.sheetController.formatSelection(DecreaseFontSizeIntent());
                                  },
                                ),
                                MaterialToolbarFontSizeTextfield(
                                  selectedFontSize: selectionStyle.fontSize ?? 0,
                                  onChanged: (double value) {},
                                ),
                                MaterialToolbarIconButton.small(
                                  icon: SheetIcons.add,
                                  onTap: () {
                                    widget.sheetController.formatSelection(IncreaseFontSizeIntent());
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
                                        .formatSelection(ToggleFontWeightIntent());
                                  },
                                ),
                                MaterialToolbarIconButton(
                                  icon: SheetIcons.format_italic,
                                  active: selectionStyle.fontStyle == FontStyle.italic,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(ToggleFontStyleIntent());
                                  },
                                ),
                                MaterialToolbarIconButton(
                                  icon: SheetIcons.strikethrough,
                                  active: selectionStyle.decoration == TextDecoration.lineThrough,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(ToggleTextDecorationIntent(value: TextDecoration.lineThrough));
                                  },
                                ),
                                MaterialToolbarColorButton(
                                  icon: SheetIcons.format_color_text,
                                  color: selectionStyle.color ?? defaultTextStyle.color ?? Colors.black,
                                  onSelected: (Color color) {
                                    widget.sheetController.formatSelection(SetFontColorIntent(color: color));
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
                                    widget.sheetController.formatSelection(SetBackgroundColorIntent(color: color));
                                  },
                                ),
                                MaterialBorderButton(
                                  onChanged: (BorderEdges edges, Color color, double width) {
                                    widget.sheetController.formatSelection(SetBorderIntent(
                                      edges: edges,
                                      borderSide: BorderSide(color: color, width: width),
                                      selectedCells: widget.sheetController.selectedCells,
                                    ));
                                  },
                                ),
                                MaterialToolbarIconButton.withDropdown(icon: SheetIcons.cell_merge, onTap: () {}),
                                const MaterialToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <Widget>[
                                MaterialTextAlignButton(
                                  selectedTextAlign: selectionStyle.textAlignHorizontal,
                                  onChanged: (TextAlign value) {
                                    widget.sheetController.formatSelection(SetHorizontalAlignIntent(value));
                                  },
                                ),
                                MaterialTextVerticalAlignButton(
                                  selectedTextAlign: selectionStyle.textAlignVertical,
                                  onChanged: (TextVerticalAlign value) {
                                    widget.sheetController.formatSelection(SetVerticalAlignIntent(value));
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
