import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/core/config/sheet_constants.dart';
import 'package:sheets/core/events/sheet_formatting_events.dart';
import 'package:sheets/core/selection/selection_style.dart';
import 'package:sheets/core/selection/sheet_selection.dart';
import 'package:sheets/core/selection/types/sheet_range_selection.dart';
import 'package:sheets/core/selection/types/sheet_single_selection.dart';
import 'package:sheets/core/sheet_controller.dart';
import 'package:sheets/core/sheet_index.dart';
import 'package:sheets/core/values/formats/sheet_value_format.dart';
import 'package:sheets/core/values/sheet_text_span.dart';
import 'package:sheets/utils/border_edges.dart';
import 'package:sheets/utils/formatters/style/cell_style_format.dart';
import 'package:sheets/utils/formatters/style/sheet_style_format.dart';
import 'package:sheets/utils/formatters/style/text_style_format.dart';
import 'package:sheets/utils/text_overflow_behavior.dart';
import 'package:sheets/utils/text_rotation.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_button.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_menu_button.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_omnibox.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_border_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_color_fill_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_color_font_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_font_family_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_font_size_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_format_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_merge_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_rotation_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_text_align_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_text_valign_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_text_wrap_btn.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/goog_toolbar_zoom_btn.dart';
import 'package:sheets/widgets/goog/toolbar/goog_toolbar_button_list.dart';
import 'package:sheets/widgets/sheet_theme.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbar extends StatefulWidget {
  const GoogToolbar({
    required this.sheetController,
    super.key,
  });

  final SheetController sheetController;

  @override
  State<StatefulWidget> createState() => _GoogToolbarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetController>('sheetController', sheetController));
  }
}

class _GoogToolbarState extends State<GoogToolbar> {
  @override
  Widget build(BuildContext context) {
    return SheetTheme(
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10, top: 1),
        decoration: const BoxDecoration(
          color: Color(0xfff9fbfd),
        ),
        child: Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: const Color(0xfff0f4f9),
            borderRadius: BorderRadius.circular(45),
          ),
          child: ListenableBuilder(
            listenable: Listenable.merge(<Listenable?>[
              widget.sheetController.editableCellNotifier,
              widget.sheetController,
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
                        child: GoogToolbarButtonList(
                          sections: <GoogToolbarButtonGroup>[
                            const GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarOmnibox.expanded(),
                              ],
                              smallButtons: <StaticSizeWidget>[
                                GoogToolbarOmnibox.collapsed(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 11, bottom: 8),
                                  child: const GoogIcon(SheetIcons.docs_icon_undo_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 11, bottom: 8),
                                  child: const GoogIcon(SheetIcons.docs_icon_redo_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 9, bottom: 7),
                                  child: const GoogIcon(SheetIcons.docs_icon_print_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                                  child: const GoogIcon(SheetIcons.docs_icon_paint_format_20),
                                  onTap: () {},
                                ),
                                GoogToolbarZoomBtn(value: 100, onChanged: (_) {}),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarButton(
                                  child: const GoogText('zł'),
                                  onTap: () {
                                    widget.sheetController.resolve(
                                        FormatSelectionEvent(SetValueFormatIntent(format: (_) => SheetNumberFormat.currency())));
                                  },
                                ),
                                GoogToolbarButton(
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(
                                        SetValueFormatIntent(format: (_) => SheetNumberFormat.percentPattern())));
                                  },
                                  child: const GoogText('%'),
                                ),
                                GoogToolbarButton(
                                  padding: const EdgeInsets.only(top: 8, bottom: 6),
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetValueFormatIntent(
                                      format: (SheetValueFormat? previous) {
                                        return previous?.decreaseDecimal() ?? SheetNumberFormat.decimalPattern();
                                      },
                                    )));
                                  },
                                  child: const GoogIcon(SheetIcons.docs_icon_decimal_decrease_20),
                                ),
                                GoogToolbarButton(
                                  padding: const EdgeInsets.only(top: 8, bottom: 6),
                                  child: const GoogIcon(SheetIcons.docs_icon_decimal_increase_20),
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetValueFormatIntent(
                                      format: (SheetValueFormat? previous) {
                                        return previous?.increaseDecimal() ?? SheetNumberFormat.decimalPattern();
                                      },
                                    )));
                                  },
                                ),
                                GoogToolbarFormatBtn(
                                  onChanged: (SheetValueFormat? value) {
                                    widget.sheetController
                                        .resolve(FormatSelectionEvent(SetValueFormatIntent(format: (_) => value)));
                                  },
                                ),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarFontFamilyBtn(
                                  value: selectionStyle.textStyle.fontFamily,
                                  onChanged: (String fontFamily) {
                                    widget.sheetController
                                        .resolve(FormatSelectionEvent(SetFontFamilyIntent(fontFamily: fontFamily)));
                                  },
                                ),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarButton(
                                  height: 24,
                                  width: 24,
                                  padding: const EdgeInsets.all(7),
                                  child: const GoogIcon(SheetIcons.docs_icon_remove_20),
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(DecreaseFontSizeIntent()));
                                  },
                                ),
                                GoogToolbarFontSizeBtn(
                                  value: selectionStyle.fontSize.pt,
                                  onChanged: (double value) {
                                    widget.sheetController
                                        .resolve(FormatSelectionEvent(SetFontSizeIntent(fontSize: FontSize.fromPoints(value))));
                                  },
                                ),
                                GoogToolbarButton(
                                  height: 24,
                                  width: 24,
                                  padding: const EdgeInsets.all(7),
                                  child: const GoogIcon(SheetIcons.docs_icon_add_20),
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(IncreaseFontSizeIntent()));
                                  },
                                ),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarButton(
                                  selected: selectionStyle.fontWeight == FontWeight.bold,
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(ToggleFontWeightIntent()));
                                  },
                                  child: const GoogIcon(SheetIcons.docs_icon_bold_20),
                                ),
                                GoogToolbarButton(
                                  selected: selectionStyle.fontStyle == FontStyle.italic,
                                  onTap: () {
                                    widget.sheetController.resolve(FormatSelectionEvent(ToggleFontStyleIntent()));
                                  },
                                  child: const GoogIcon(SheetIcons.docs_icon_italic_20),
                                ),
                                GoogToolbarButton(
                                  selected: selectionStyle.decoration == TextDecoration.lineThrough,
                                  onTap: () {
                                    widget.sheetController.resolve(
                                        FormatSelectionEvent(ToggleTextDecorationIntent(value: TextDecoration.lineThrough)));
                                  },
                                  padding: const EdgeInsets.only(top: 9, bottom: 8),
                                  child: const GoogIcon(SheetIcons.docs_icon_strikethrough_20),
                                ),
                                GoogToolbarColorFontBtn(
                                  value: selectionStyle.color ?? defaultTextStyle.color ?? Colors.black,
                                  onChanged: (Color color) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetFontColorIntent(color: color)));
                                  },
                                ),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarCellColorBtn(
                                  value: selectionStyle.backgroundColor ?? Colors.white,
                                  onChanged: (Color color) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetBackgroundColorIntent(color: color)));
                                  },
                                ),
                                GoogToolbarBorderBtn(
                                  onChanged: (BorderEdges edges, Color color, double width) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetBorderIntent(
                                      edges: edges,
                                      borderSide: BorderSide(color: color, width: width),
                                      selectedCells: widget.sheetController.selectedCells,
                                    )));
                                  },
                                ),
                                () {
                                  SheetSelection selection = widget.sheetController.selection.value;
                                  bool merged = selection is SheetSingleSelection && selection.mainCell is MergedCellIndex;
                                  bool canMerge = selection is SheetRangeSelection;

                                  return GoogToolbarMergeBtn(
                                    merged: merged,
                                    canMerge: canMerge,
                                    canMergeVertically: canMerge,
                                    canMergeHorizontally: canMerge,
                                    canSplit: merged,
                                    onMerge: () {
                                      widget.sheetController.resolve(MergeSelectionEvent());
                                    },
                                    onMergeHorizontally: () {
                                      widget.sheetController.resolve(MergeSelectionEvent());
                                    },
                                    onMergeVertically: () {
                                      widget.sheetController.resolve(MergeSelectionEvent());
                                    },
                                    onSplit: () {
                                      widget.sheetController.resolve(UnmergeSelectionEvent());
                                    },
                                  );
                                }(),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarTextAlignBtn(
                                  value: selectionStyle.textAlignHorizontal,
                                  onChanged: (TextAlign value) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetHorizontalAlignIntent(value)));
                                  },
                                ),
                                GoogToolbarTextValignBtn(
                                  value: selectionStyle.textAlignVertical,
                                  onChanged: (TextAlignVertical value) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetVerticalAlignIntent(value)));
                                  },
                                ),
                                GoogToolbarTextWrapBtn(
                                  value: TextOverflowBehavior.overflow,
                                  onChanged: (TextOverflowBehavior value) {
                                    // widget.sheetController.formatSelection(UpdateVerticalAlignAction(selectionStyle, value));
                                  },
                                ),
                                GoogToolbarRotationBtn(
                                  value: selectionStyle.cellStyle.rotation,
                                  onChanged: (TextRotation rotation) {
                                    widget.sheetController.resolve(FormatSelectionEvent(SetRotationIntent(rotation)));
                                  },
                                ),
                                const _GoogToolbarDivider(),
                              ],
                            ),
                            GoogToolbarButtonGroup(
                              buttons: <StaticSizeWidget>[
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 8, bottom: 6),
                                  child: const GoogIcon(SheetIcons.docs_icon_link_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 8, bottom: 6),
                                  child: const GoogIcon(SheetIcons.docs_icon_add_comment_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 9, bottom: 7),
                                  child: const GoogIcon(SheetIcons.docs_icon_insert_chart_20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                                  child: const GoogIcon(SheetIcons.docs_icon_filter_alt_20),
                                  onTap: () {},
                                ),
                                GoogToolbarMenuButton(
                                  disabled: true,
                                  childPadding: const EdgeInsets.only(top: 7, bottom: 6),
                                  child: const GoogIcon(SheetIcons.docs_icon_table_view_20x20),
                                  onTap: () {},
                                ),
                                GoogToolbarButton(
                                  disabled: true,
                                  padding: const EdgeInsets.only(top: 9, bottom: 8),
                                  child: const GoogIcon(SheetIcons.docs_icon_insert_function_20),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GoogToolbarButton(
                        disabled: true,
                        child: const GoogIcon(SheetIcons.docs_icon_expand_less_20),
                        onTap: () {},
                      ),
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

class _GoogToolbarDivider extends StatelessWidget implements StaticSizeWidget {
  const _GoogToolbarDivider({
    Size? size,
    EdgeInsets? margin,
  })  : _size = size ?? const Size(1, 20),
        _margin = margin ?? const EdgeInsets.symmetric(horizontal: 3);

  final Size _size;
  final EdgeInsets _margin;

  @override
  Size get size => _size;

  @override
  EdgeInsets get margin => _margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _size.height,
      margin: _margin,
      child: VerticalDivider(color: const Color(0xffc7c7c7), width: _size.width, thickness: _size.width),
    );
  }
}
