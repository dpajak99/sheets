import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/widgets/material/material_format_dropdown.dart';
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
          child: ListenableBuilder(
            listenable: Listenable.merge(<Listenable?>[
              widget.sheetController.activeCellNotifier,
              widget.sheetController.activeCellNotifier.value?.controller,
              widget.sheetController.activeCellNotifier.value?.controller.selectionNotifier,
              widget.sheetController.properties,
              widget.sheetController.selection,
            ]),
            builder: (BuildContext context, _) {
              TextStyle textStyle = widget.sheetController.getActiveStyle();

              return Row(
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
                        ToolbarButtonsSection(
                          buttons: <ToolbarItem>[
                            const ToolbarButton.text('zloty'),
                            const ToolbarButton.icon(SheetIcons.percentage),
                            const ToolbarButton.icon(SheetIcons.decimal_decrease),
                            const ToolbarButton.icon(SheetIcons.decimal_increase),
                            ToolbarPopupButton(
                              child: const ToolbarButton.text('123'),
                              popupBuilder: (BuildContext context) => const MaterialFormatDropdown(),
                            ),
                            const ToolbarDivider(),
                          ],
                        ),
                        const ToolbarButtonsSection(
                          buttons: <ToolbarItem>[
                            ToolbarTextDropdownButton(value: 'Default', width: 97),
                            ToolbarDivider(),
                          ],
                        ),
                        ToolbarButtonsSection(
                          buttons: <ToolbarItem>[
                            ToolbarButton.iconSmall(
                              SheetIcons.remove,
                              onTap: () {
                                double fontSize = (textStyle.fontSize ?? 14) - 1;
                                widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                  fontSize: fontSize,
                                ));
                              },
                            ),
                            ToolbarTextField(value: textStyle.fontSize?.toStringAsFixed(0) ?? ''),
                            ToolbarButton.iconSmall(
                              SheetIcons.add,
                              onTap: () {
                                double fontSize = (textStyle.fontSize ?? 14) + 1;
                                widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                  fontSize: fontSize,
                                ));
                                widget.sheetController.properties.ensureMinimalRowsHeight(
                                  widget.sheetController.selection.value.selectedCells
                                      .map((CellIndex cellIndex) => cellIndex.row)
                                      .toSet()
                                      .toList(),
                                  fontSize + 9,
                                );
                              },
                            ),
                            const ToolbarDivider(),
                          ],
                        ),
                        ToolbarButtonsSection(
                          buttons: <ToolbarItem>[
                            ToolbarButton.icon(
                              SheetIcons.format_bold,
                              active: textStyle.fontWeight == FontWeight.bold,
                              onTap: () {
                                if (textStyle.fontWeight == FontWeight.bold) {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    fontWeight: FontWeight.normal,
                                  ));
                                } else {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    fontWeight: FontWeight.bold,
                                  ));
                                }
                              },
                            ),
                            ToolbarButton.icon(
                              SheetIcons.format_italic,
                              active: textStyle.fontStyle == FontStyle.italic,
                              onTap: () {
                                if (textStyle.fontStyle == FontStyle.italic) {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    fontStyle: FontStyle.normal,
                                  ));
                                } else {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    fontStyle: FontStyle.italic,
                                  ));
                                }
                              },
                            ),
                            ToolbarButton.icon(
                              SheetIcons.strikethrough,
                              active: textStyle.decoration == TextDecoration.lineThrough,
                              onTap: () {
                                if (textStyle.decoration == TextDecoration.lineThrough) {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    decoration: TextDecoration.none,
                                  ));
                                } else {
                                  widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                    decoration: TextDecoration.lineThrough,
                                  ));
                                }
                              },
                            ),
                            ToolbarColorPickerButton(
                              icon: SheetIcons.format_color_text,
                              color: textStyle.color ?? defaultTextStyle.color!,
                              onColorChanged: (Color color) {
                                widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                  color: color,
                                ));
                              },
                            ),
                            const ToolbarDivider(),
                          ],
                        ),
                        ToolbarButtonsSection(
                          buttons: <ToolbarItem>[
                            ToolbarColorPickerButton(
                              icon: SheetIcons.format_color_fill,
                              color: textStyle.backgroundColor ?? Colors.white,
                              onColorChanged: (Color color) {
                                widget.sheetController.formatSelection(TextStyleUpdateRequest(
                                  backgroundColor: color,
                                ));
                              },
                            ),
                            const ToolbarButton.icon(SheetIcons.border_all),
                            const ToolbarDropdownButtonSeparated(icon: SheetIcons.cell_merge),
                            const ToolbarDivider(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
