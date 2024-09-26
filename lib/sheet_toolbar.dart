import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheets/config/app_icons/asset_icon.dart';

class SheetToolbar extends StatefulWidget {
  const SheetToolbar({super.key});

  @override
  State<StatefulWidget> createState() => _SheetToolbarState();
}

class _SheetToolbarState extends State<SheetToolbar> {
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
        child: Row(
          children: [
            Container(
              width: 100,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(45),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Menu',
                    style: TextStyle(color: Color(0xff444746), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            const ToolbarIcon(SheetIcons.undo),
            const ToolbarIcon(SheetIcons.redo),
            const ToolbarIcon(SheetIcons.print),
            const ToolbarIcon(SheetIcons.paint),
            const ToolbarText('100%'),
            const ToolbarDivider(),
            const ToolbarText('zloty'),
            const ToolbarText('%'),
            const ToolbarIcon(SheetIcons.decimal_decrease),
            const ToolbarIcon(SheetIcons.decimal_increase),
            const ToolbarText('123'),
            const ToolbarDivider(),
            const ToolbarText('Domyślny'),
            const ToolbarDivider(),
            const ToolbarIcon(SheetIcons.add),
            const ToolbarText('10'),
            const ToolbarIcon(SheetIcons.remove),
            const ToolbarDivider(),
            const ToolbarIcon(SheetIcons.format_bold),
            const ToolbarIcon(SheetIcons.format_italic),
            const ToolbarIcon(SheetIcons.strikethrough),
            const ToolbarIcon(SheetIcons.format_color_text),
            const ToolbarDivider(),
            const ToolbarIcon(SheetIcons.format_color_fill),
            const ToolbarIcon(SheetIcons.border_all),
            const ToolbarIcon(SheetIcons.cell_merge),
            const ToolbarDivider(),
            const ToolbarIcon(SheetIcons.format_align_left),
            const ToolbarIcon(SheetIcons.vertical_align_bottom),
            const ToolbarIcon(SheetIcons.format_text_overflow),
            const ToolbarIcon(SheetIcons.text_rotation_none),
            const ToolbarDivider(),
            const ToolbarIcon(SheetIcons.link),
            const ToolbarIcon(SheetIcons.add_comment),
            const ToolbarIcon(SheetIcons.insert_chart),
            const ToolbarIcon(SheetIcons.filter_alt),
            const ToolbarIcon(SheetIcons.table_view),
            const ToolbarIcon(SheetIcons.functions),
            const Spacer(),
            const ToolbarIcon(SheetIcons.keyboard_arrow_up),
            const SizedBox(width: 13)
          ],
        ),
      ),
    );
  }
}

class ToolbarText extends StatelessWidget {
  final String text;

  const ToolbarText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ToolbarButton(
      child: Text(
        text,
        style: textTheme.labelMedium?.copyWith(
          color: const Color(0xff47484b),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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

class ToolbarIcon extends StatelessWidget {
  final AssetIconData iconData;

  const ToolbarIcon(this.iconData, {super.key});

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      child: AssetIcon(iconData, color: const Color(0xff444746), size: 18),
    );
  }
}

class ToolbarButton extends StatefulWidget {
  final Widget child;

  const ToolbarButton({required this.child, super.key});

  @override
  State<StatefulWidget> createState() => _ToolbarButtonState();
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
            padding: const EdgeInsets.all(5),
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
}
