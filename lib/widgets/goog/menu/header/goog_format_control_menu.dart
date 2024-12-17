import 'package:flutter/cupertino.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/generated/strings.g.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_text.dart';
import 'package:sheets/widgets/goog/menu/goog_menu_vertical.dart';

class GoogFormatControlMenu extends StatelessWidget {
  const GoogFormatControlMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogMenuVertical(
      width: 322,
      children: <Widget>[
        GoogMenuItem(
          label: GoogText(t.menu.format.theme),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paint_palette_theme),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.number),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_numbers_123),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: GoogText(t.menu.format.number_options.automatic), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.plain_text), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.number), trailing: const GoogText('1 000,12'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.percent), trailing: const GoogText('10,12%'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.scientific), trailing: const GoogText('1,01E+03'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.accounting), trailing: const GoogText('(1 000,12) zł'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.financial), trailing: const GoogText('(1 000,12)'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.currency), trailing: const GoogText('1 000,12 zł'), disabled: true),
                GoogMenuItem(
                    label: GoogText(t.menu.format.number_options.currency_rounded), trailing: const GoogText('1 000 zł'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.date), trailing: const GoogText('2008_09_26'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.time), trailing: const GoogText('15:59:00'), disabled: true),
                GoogMenuItem(
                    label: GoogText(t.menu.format.number_options.date_time), trailing: const GoogText('2008_09_26 15:59:00'), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.duration), trailing: const GoogText('24:01:00'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: const GoogText('26_09_2008'), disabled: true),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.custom_currency), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.custom_date), disabled: true),
                GoogMenuItem(label: GoogText(t.menu.format.number_options.custom_number), disabled: true),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.text),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_bold),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.format.text_options.bold),
                  trailing: const GoogText('Ctrl+B'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_bold),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.text_options.italic),
                  trailing: const GoogText('Ctrl+I'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_italic),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.text_options.underline),
                  trailing: const GoogText('Ctrl+U'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_underline),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.text_options.strikethrough),
                  trailing: const GoogText('Alt+Shift+5'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_strikethrough),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.alignment),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_left),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.left),
                  trailing: const GoogText('Ctrl+Shift+L'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_left),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.center),
                  trailing: const GoogText('Ctrl+Shift+E'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_center),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.right),
                  trailing: const GoogText('Ctrl+Shift+R'),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_right),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.top),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_top),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.middle),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_middle),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.alignment_options.bottom),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_align_bottom),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.wrapping),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_wrap),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.format.wrapping_options.overflow),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_overflow),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.wrapping_options.wrap),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_wrap),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.wrapping_options.clip),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_wrap_text_clip),
                  disabled: true,
                ),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.rotation),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_up),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.none),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_none),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.tilt_up),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_up),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.tilt_down),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_angle_down),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.stack_vertically),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_vertical_stack),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.rotate_up),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_up),
                  disabled: true,
                ),
                GoogMenuItem(
                  label: GoogText(t.menu.format.rotation_options.rotate_down),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_text_rotate_down),
                  disabled: true,
                ),
                const GoogMenuSeperator.expand(),
                GoogSubmenuItem(
                  level: 3,
                  label: GoogText(t.menu.format.rotation_options.custom_angle),
                  leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_right_angle),
                  popupBuilder: (BuildContext context) {
                    return GoogMenuVertical(
                      width: 87,
                      children: <Widget>[
                        GoogMenuItem(label: const GoogText('-90°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-75°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-60°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-45°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-30°'), disabled: true),
                        GoogMenuItem(label: const GoogText('-15°'), disabled: true),
                        GoogMenuItem(label: const GoogText('0°'), disabled: true),
                        GoogMenuItem(label: const GoogText('15°'), disabled: true),
                        GoogMenuItem(label: const GoogText('30°'), disabled: true),
                        GoogMenuItem(label: const GoogText('45°'), disabled: true),
                        GoogMenuItem(label: const GoogText('60°'), disabled: true),
                        GoogMenuItem(label: const GoogText('75°'), disabled: true),
                        GoogMenuItem(label: const GoogText('90°'), disabled: true),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.font_size),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_font_text_size),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 87,
              children: <Widget>[
                GoogMenuItem(label: const GoogText('6'), disabled: true),
                GoogMenuItem(label: const GoogText('7'), disabled: true),
                GoogMenuItem(label: const GoogText('8'), disabled: true),
                GoogMenuItem(label: const GoogText('9'), disabled: true),
                GoogMenuItem(label: const GoogText('10'), disabled: true),
                GoogMenuItem(label: const GoogText('11'), disabled: true),
                GoogMenuItem(label: const GoogText('12'), disabled: true),
                GoogMenuItem(label: const GoogText('14'), disabled: true),
                GoogMenuItem(label: const GoogText('18'), disabled: true),
                GoogMenuItem(label: const GoogText('36'), disabled: true),
              ],
            );
          },
        ),
        GoogSubmenuItem(
          label: GoogText(t.menu.format.merge_cells),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_merge),
          popupBuilder: (BuildContext context) {
            return GoogMenuVertical(
              width: 262,
              children: <Widget>[
                GoogMenuItem(label: GoogText(t.menu.format.merge_cells_options.merge_all), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: GoogText(t.menu.format.merge_cells_options.merge_vertically), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: GoogText(t.menu.format.merge_cells_options.merge_horizontally), disabled: true, iconPlaceholderVisible: false),
                GoogMenuItem(label: GoogText(t.menu.format.merge_cells_options.unmerge), disabled: true, iconPlaceholderVisible: false),
              ],
            );
          },
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.format.convert_to_table),
          trailing: const GoogText('Ctrl+Alt+T'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_table_chart),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.format.conditional_formatting),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_paintbrush),
          disabled: true,
        ),
        GoogMenuItem(
          label: GoogText(t.menu.format.alternating_colors),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_opacity),
          disabled: true,
        ),
        const GoogMenuSeperator.expand(),
        GoogMenuItem(
          label: GoogText(t.menu.format.clear_formatting),
          trailing: const GoogText(r'Ctrl+\'),
          leading: const GoogIcon(SheetIcons.docs_icon_editors_ia_clear_format),
          disabled: true,
        ),
      ],
    );
  }
}
