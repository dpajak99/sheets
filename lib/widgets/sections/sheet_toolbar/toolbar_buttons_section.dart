import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/toolbar/buttons/generic/toolbar_icon_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';

class ToolbarButtonsSectionWrapper extends StatefulWidget {
  const ToolbarButtonsSectionWrapper({
    required this.sections,
    super.key,
  });

  final List<ToolbarButtonsSection> sections;

  @override
  State<StatefulWidget> createState() => _ToolbarButtonsSectionWrapperState();
}

class _ToolbarButtonsSectionWrapperState extends State<ToolbarButtonsSectionWrapper> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        List<Widget> visibleSections = _getVisibleSections(constraints);

        return Row(
          children: <Widget>[
            ...visibleSections,
            if (visibleSections.length != widget.sections.length)
              ToolbarIconButton(
                icon: SheetIcons.more_vert,
                onTap: () {},
              ),
          ],
        );
      },
    );
  }

  List<Widget> _getVisibleSections(BoxConstraints constraints) {
    List<ToolbarButtonsSection> visibleSections = <ToolbarButtonsSection>[];

    List<ToolbarButtonsSection> sections = widget.sections;
    double totalSectionsWidth = sections.fold<double>(0, (double previousValue, ToolbarButtonsSection element) {
      return previousValue + element.getSectionWidth(false);
    });

    double maxWidth = constraints.maxWidth - 75;

    bool useSmall = totalSectionsWidth > maxWidth;

    double widthCursor = 0;
    for (int i = 0; i < sections.length; i++) {
      ToolbarButtonsSection section = sections[i];

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

class ToolbarButtonsSection extends StatelessWidget {
  const ToolbarButtonsSection({
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

  ToolbarButtonsSection toSmall() {
    return ToolbarButtonsSection(buttons: smallButtons.isNotEmpty ? smallButtons : buttons);
  }
}
