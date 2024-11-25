import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/utils/text_vertical_align.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_text_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_border_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_color_fill_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_color_font_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_font_family_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_font_size_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_text_align_horizontal_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_text_align_vertical_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_text_overflow_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_text_rotation_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_value_format_button.dart';
import 'package:sheets/widgets/material/toolbar/buttons/toolbar_zoom_button.dart';
import 'package:sheets/widgets/material/toolbar/toolbar_divider.dart';
import 'package:sheets/widgets/material/toolbar/toolbar_searchbox.dart';
import 'package:sheets/widgets/sections/sheet_toolbar/toolbar_buttons_section.dart';
import 'package:sheets/widgets/sheet_theme.dart';
import 'package:sheets/widgets/static_size_widget.dart';

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
              widget.sheetController.editableCellNotifier,
              widget.sheetController.dataManager,
              widget.sheetController.selection,
            ]),
            builder: (BuildContext context, _) {
              return ListenableBuilder(
                listenable: Listenable.merge(<Listenable?>[
                  widget.sheetController.editableCellNotifier.value?.controller,
                ]),
                builder: (BuildContext context, _) {
                  SelectionStyle selectionStyle = widget.sheetController.getSelectionStyle();

                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: ToolbarButtonsSectionWrapper(
                          sections: <ToolbarButtonsSection>[
                            const ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarSearchbox.expanded(),
                              ],
                              smallButtons: <StaticSizeWidget>[
                                ToolbarSearchbox.collapsed(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarIconButton(icon: SheetIcons.undo, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.redo, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.print, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.paint, onTap: () {}),
                                ToolbarZoomButton(value: 100, onChanged: (_) {}),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarTextButton(
                                    text: NumberFormat.currency().currencySymbol,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: SheetNumberFormat.currency()));
                                    }),
                                ToolbarIconButton(
                                    icon: SheetIcons.percentage,
                                    onTap: () {
                                      widget.sheetController
                                          .formatSelection(SetValueFormatIntent(format: SheetNumberFormat.percentPattern()));
                                    }),
                                ToolbarIconButton(
                                    icon: SheetIcons.decimal_decrease,
                                    onTap: () {
                                      widget.sheetController.formatSelection(
                                          SetValueFormatIntent(format: selectionStyle.valueFormat.decreaseDecimal()));
                                    }),
                                ToolbarIconButton(
                                    icon: SheetIcons.decimal_increase,
                                    onTap: () {
                                      widget.sheetController.formatSelection(
                                          SetValueFormatIntent(format: selectionStyle.valueFormat.increaseDecimal()));
                                    }),
                                ToolbarValueFormatButton(
                                  onChanged: (SheetValueFormat? value) {
                                    widget.sheetController.formatSelection(SetValueFormatIntent(format: value));
                                  },
                                ),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarFontFamilyButton(
                                  value: selectionStyle.textStyle.fontFamily,
                                  onChanged: (String fontFamily) {
                                    widget.sheetController.formatSelection(SetFontFamilyIntent(fontFamily: fontFamily));
                                  },
                                ),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarIconButton.small(
                                  icon: SheetIcons.remove,
                                  onTap: () {
                                    widget.sheetController.formatSelection(DecreaseFontSizeIntent());
                                  },
                                ),
                                ToolbarFontSizeButton(
                                  value: selectionStyle.fontSize ?? 0,
                                  onChanged: (double value) {
                                    widget.sheetController.formatSelection(SetFontSizeIntent(fontSize: value));
                                  },
                                ),
                                ToolbarIconButton.small(
                                  icon: SheetIcons.add,
                                  onTap: () {
                                    widget.sheetController.formatSelection(IncreaseFontSizeIntent());
                                  },
                                ),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarIconButton(
                                  icon: SheetIcons.format_bold,
                                  selected: selectionStyle.fontWeight == FontWeight.bold,
                                  onTap: () {
                                    widget.sheetController.formatSelection(ToggleFontWeightIntent());
                                  },
                                ),
                                ToolbarIconButton(
                                  icon: SheetIcons.format_italic,
                                  selected: selectionStyle.fontStyle == FontStyle.italic,
                                  onTap: () {
                                    widget.sheetController.formatSelection(ToggleFontStyleIntent());
                                  },
                                ),
                                ToolbarIconButton(
                                  icon: SheetIcons.strikethrough,
                                  selected: selectionStyle.decoration == TextDecoration.lineThrough,
                                  onTap: () {
                                    widget.sheetController
                                        .formatSelection(ToggleTextDecorationIntent(value: TextDecoration.lineThrough));
                                  },
                                ),
                                ToolbarColorFontButton(
                                  value: selectionStyle.color ?? defaultTextStyle.color ?? Colors.black,
                                  onChanged: (Color color) {
                                    widget.sheetController.formatSelection(SetFontColorIntent(color: color));
                                  },
                                ),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarColorFillButton(
                                  value: selectionStyle.backgroundColor ?? defaultTextStyle.backgroundColor ?? Colors.white,
                                  onChanged: (Color? color) {
                                    widget.sheetController.formatSelection(SetBackgroundColorIntent(color: color));
                                  },
                                ),
                                ToolbarBorderButton(
                                  onChanged: (BorderEdges edges, Color color, double width) {
                                    widget.sheetController.formatSelection(SetBorderIntent(
                                      edges: edges,
                                      borderSide: BorderSide(color: color, width: width),
                                      selectedCells: widget.sheetController.selectedCells,
                                    ));
                                  },
                                ),
                                ToolbarIconButton.withDropdown(icon: SheetIcons.cell_merge, onTap: () {}),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarTextAlignHorizontalButton(
                                  value: selectionStyle.textAlignHorizontal,
                                  onChanged: (TextAlign value) {
                                    widget.sheetController.formatSelection(SetHorizontalAlignIntent(value));
                                  },
                                ),
                                ToolbarTextAlignVerticalButton(
                                  value: selectionStyle.textAlignVertical,
                                  onChanged: (TextVerticalAlign value) {
                                    widget.sheetController.formatSelection(SetVerticalAlignIntent(value));
                                  },
                                ),
                                ToolbarTextOverflowButton(
                                  value: TextOverflowBehavior.overflow,
                                  onChanged: (TextOverflowBehavior value) {
                                    // widget.sheetController.formatSelection(UpdateVerticalAlignAction(selectionStyle, value));
                                  },
                                ),
                                ToolbarTextRotationButton(
                                  value: TextRotation.none,
                                  onChanged: (TextRotation rotation) {
                                    widget.sheetController.formatSelection(SetRotationIntent(rotation));
                                  },
                                ),
                                const ToolbarDivider(),
                              ],
                            ),
                            ToolbarButtonsSection(
                              buttons: <StaticSizeWidget>[
                                ToolbarIconButton(icon: SheetIcons.link, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.add_comment, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.insert_chart, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.filter_alt, onTap: () {}),
                                ToolbarIconButton.withDropdown(icon: SheetIcons.table_view, onTap: () {}),
                                ToolbarIconButton(icon: SheetIcons.functions, onTap: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ToolbarIconButton(icon: SheetIcons.arrow_up, onTap: () {}),
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
