import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';

class SheetSectionToolbar extends StatefulWidget {
  const SheetSectionToolbar({super.key});

  @override
  State<StatefulWidget> createState() => _SheetSectionToolbarState();
}

class _SheetSectionToolbarState extends State<SheetSectionToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xfff9fbfd),
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xffeef2f9),
          borderRadius: BorderRadius.circular(45),
        ),
        child: const Row(
          children: <Widget>[
            ButtonsSection(
              endDivider: false,
              buttons: <Widget>[
                ToolbarSearchbar(),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarIconButton(SheetIcons.undo),
                ToolbarIconButton(SheetIcons.redo),
                ToolbarIconButton(SheetIcons.print),
                ToolbarIconButton(SheetIcons.paint),
                ToolbarTextButtonDropdown('100%'),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarTextButton('zloty', padding: EdgeInsets.symmetric(horizontal: 1)),
                ToolbarTextButton('%'),
                ToolbarIconButton(SheetIcons.decimal_decrease),
                ToolbarIconButton(SheetIcons.decimal_increase),
                ToolbarTextButton('123', textSize: 12),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarTextButtonDropdown('Default'),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarIconButton(SheetIcons.add),
                ToolbarTextDropdown('10'),
                ToolbarIconButton(SheetIcons.remove),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarIconButton(SheetIcons.format_bold),
                ToolbarIconButton(SheetIcons.format_italic),
                ToolbarIconButton(SheetIcons.strikethrough),
                ToolbarIconButton(SheetIcons.format_color_text),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarIconButton(SheetIcons.format_color_fill),
                ToolbarIconButton(SheetIcons.border_all),
                ToolbarIconDropdownButton(SheetIcons.cell_merge),
              ],
            ),
            ButtonsSection(
              buttons: <Widget>[
                ToolbarIconDropdownButton(SheetIcons.format_align_left),
                ToolbarIconDropdownButton(SheetIcons.vertical_align_bottom),
                ToolbarIconDropdownButton(SheetIcons.format_text_overflow),
                ToolbarIconDropdownButton(SheetIcons.text_rotation_none),
              ],
            ),
            ButtonsSection(
              endDivider: false,
              buttons: <Widget>[
                ToolbarIconButton(SheetIcons.link),
                ToolbarIconButton(SheetIcons.add_comment),
                ToolbarIconButton(SheetIcons.insert_chart),
                ToolbarIconButton(SheetIcons.filter_alt),
                ToolbarIconDropdownButton(SheetIcons.table_view),
                ToolbarIconButton(SheetIcons.functions),
              ],
            ),
            Spacer(),
            ToolbarIconButton(SheetIcons.keyboard_arrow_up),
            SizedBox(width: 13)
          ],
        ),
      ),
    );
  }
}

class ToolbarSearchbar extends StatelessWidget {
  const ToolbarSearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search, size: 19),
          const SizedBox(width: 8),
          Text(
            'Menu',
            style: GoogleFonts.roboto(
              color: const Color(0xff444746),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    required this.buttons,
    this.endDivider = true,
    super.key,
  });

  final List<Widget> buttons;
  final bool endDivider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ...buttons,
        if (endDivider) const ToolbarDivider(),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('endDivider', endDivider));
  }
}

class ToolbarTextDropdown extends StatelessWidget {
  const ToolbarTextDropdown(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Color foregroundColor = const Color(0xff444746);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 1),
            constraints: BoxConstraints(minWidth: constraints.maxHeight),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: foregroundColor),
            ),
            child: Center(
              child: Text(
                text,
                style: textTheme.labelMedium?.copyWith(
                  color: foregroundColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}

class ToolbarTextButton extends StatelessWidget {
  const ToolbarTextButton(
    this.text, {
    this.textSize = 14,
    this.padding = const EdgeInsets.all(5),
    super.key,
  });

  final String text;
  final double textSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ToolbarButton(
      padding: padding,
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: const Color(0xff47484b),
          fontSize: textSize,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DoubleProperty('textSize', textSize));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
  }
}

class ToolbarTextButtonDropdown extends StatelessWidget {
  const ToolbarTextButtonDropdown(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Color foregroundColor = const Color(0xff444746);

    return ToolbarButton(
      padding: const EdgeInsets.only(left: 10, right: 5),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.4,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: foregroundColor, size: 19.5),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}

class ToolbarDivider extends StatelessWidget {
  const ToolbarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: const VerticalDivider(color: Color(0xffc7c7c7), width: 1, thickness: 1),
    );
  }
}

class ToolbarIconButton extends StatelessWidget {
  const ToolbarIconButton(this.iconData, {super.key});

  final AssetIconData iconData;

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      child: AssetIcon(iconData, color: const Color(0xff444746), size: 18),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('iconData', iconData));
  }
}

class ToolbarIconDropdownButton extends StatelessWidget {
  const ToolbarIconDropdownButton(this.iconData, {super.key});

  final AssetIconData iconData;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = const Color(0xff444746);
    return ToolbarButton(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: <Widget>[
          AssetIcon(iconData, color: foregroundColor, size: 18),
          Icon(Icons.arrow_drop_down, color: foregroundColor, size: 19.5),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('iconData', iconData));
  }
}

class ToolbarButton extends StatefulWidget {
  const ToolbarButton({
    required this.child,
    this.padding = const EdgeInsets.all(5),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  State<StatefulWidget> createState() => _ToolbarButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
  }
}

class _ToolbarButtonState extends State<ToolbarButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => hovered = true),
          onExit: (_) => setState(() => hovered = false),
          child: Container(
            padding: widget.padding,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            constraints: BoxConstraints(minWidth: constraints.maxHeight),
            decoration: BoxDecoration(
              color: hovered ? const Color(0xffe0e5ea) : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('hovered', hovered));
  }
}
