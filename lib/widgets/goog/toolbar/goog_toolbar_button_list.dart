import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/goog/generic/goog_icon.dart';
import 'package:sheets/widgets/goog/toolbar/buttons/generic/goog_toolbar_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class GoogToolbarButtonList extends StatefulWidget {
  const GoogToolbarButtonList({
    required this.sections,
    super.key,
  });

  final List<GoogToolbarButtonGroup> sections;

  @override
  State<StatefulWidget> createState() => _GoogToolbarButtonListState();
}

class _GoogToolbarButtonListState extends State<GoogToolbarButtonList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> visibleSections = _getVisibleSections(constraints);

        return Row(
          children: <Widget>[
            ...visibleSections,
            if (visibleSections.length != widget.sections.length)
              GoogToolbarButton(
                child: const GoogIcon(SheetIcons.docs_icon_expand_less_20),
                onTap: () {},
              ),
          ],
        );
      },
    );
  }

  List<Widget> _getVisibleSections(BoxConstraints constraints) {
    List<GoogToolbarButtonGroup> visibleSections = <GoogToolbarButtonGroup>[];

    List<GoogToolbarButtonGroup> sections = widget.sections;
    double totalSectionsWidth = sections.fold<double>(0, (double previousValue, GoogToolbarButtonGroup element) {
      return previousValue + element.getSectionWidth(false);
    });

    double maxWidth = constraints.maxWidth - 75;

    bool useSmall = totalSectionsWidth > maxWidth;

    double widthCursor = 0;
    for (int i = 0; i < sections.length; i++) {
      GoogToolbarButtonGroup section = sections[i];

      double sectionWidth = section.getSectionWidth(useSmall);
      if (widthCursor + sectionWidth < maxWidth) {
        widthCursor += sectionWidth;
        if (useSmall) {
          visibleSections.add(section.toSmall());
        } else {
          visibleSections.add(section);
        }
      } else {
        break;
      }
    }

    return visibleSections;
  }
}

class GoogToolbarButtonGroup extends StatelessWidget {
  const GoogToolbarButtonGroup({
    required this.buttons,
    this.smallButtons = const <StaticSizeWidget>[],
    super.key,
  });

  final List<StaticSizeWidget> buttons;
  final List<StaticSizeWidget> smallButtons;

  double getSectionWidth(bool useSmall) {
    List<StaticSizeWidget> items = useSmall && smallButtons.isNotEmpty ? smallButtons : buttons;
    return items.fold<double>(0, (double previousValue, StaticSizeWidget element) {
      return previousValue + element.size.width + element.margin.horizontal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons,
    );
  }

  GoogToolbarButtonGroup toSmall() {
    return GoogToolbarButtonGroup(buttons: smallButtons.isNotEmpty ? smallButtons : buttons);
  }
}
