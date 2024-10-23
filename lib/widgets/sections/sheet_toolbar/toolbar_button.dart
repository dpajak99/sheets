import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/mouse_state_listener.dart';

const Color _foregroundColor = Color(0xff444746);
const Color _hoverColor = Color(0xffE2E7EA);
const BorderRadius _borderRadius4 = BorderRadius.all(Radius.circular(4));
const TextStyle _textStyle = TextStyle(
  fontFamily: 'GoogleSans',
  package: 'sheets',
  fontSize: 13,
  height: 1,
  fontWeight: FontWeight.w500,
  color: _foregroundColor,
);

// Base class for all toolbar items
abstract class ToolbarItem extends StatelessWidget {
  const ToolbarItem({super.key});

  double get totalWidth;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('totalWidth', totalWidth));
  }
}

// Base class for toolbar buttons
abstract class BaseToolbarButton extends ToolbarItem {
  const BaseToolbarButton({
    required this.width,
    required this.height,
    required this.margin,
    this.padding,
    super.key,
  });

  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets? padding;

  @override
  double get totalWidth => width + margin.horizontal;

  @override
  Widget build(BuildContext context) {
    return MouseStateListener(
      onTap: () {},
      childBuilder: (Set<WidgetState> states) {
        Color? backgroundColor = states.contains(WidgetState.hovered) ? _hoverColor : null;
        return Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: _borderRadius4,
          ),
          child: buildContent(context, states),
        );
      },
    );
  }

  Widget buildContent(BuildContext context, Set<WidgetState> states);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties.add(DiagnosticsProperty<EdgeInsets?>('padding', padding));
  }
}

class ToolbarDivider extends ToolbarItem {
  const ToolbarDivider({
    this.width = 1,
    this.height = 20,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    super.key,
  });

  final double width;
  final double height;
  final EdgeInsets margin;

  @override
  double get totalWidth => width + margin.horizontal;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      child: VerticalDivider(color: const Color(0xffc7c7c7), width: width, thickness: width),
    );
  }
}

class ToolbarSearchbar extends ToolbarItem {
  const ToolbarSearchbar({
    this.width = 100,
    this.margin = const EdgeInsets.only(right: 2),
    super.key,
  });

  final double width;
  final EdgeInsets margin;

  @override
  double get totalWidth => width + margin.horizontal;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: <Widget>[
          const AssetIcon(SheetIcons.search, size: 19, color: _foregroundColor),
          const SizedBox(width: 7),
          Text(
            'Menu',
            style: GoogleFonts.roboto(
              color: _foregroundColor,
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ToolbarButton extends BaseToolbarButton {
  const ToolbarButton.icon(
    this.icon, {
    super.key,
  })  : text = null,
        iconSize = 19,
        super(
          width: 30,
          height: 30,
          padding: const EdgeInsets.only(top: 1),
          margin: const EdgeInsets.symmetric(horizontal: 1),
        );

  const ToolbarButton.iconSmall(
    this.icon, {
    super.key,
  })  : text = null,
        iconSize = 17,
        super(
          width: 24,
          height: 24,
          padding: null,
          margin: const EdgeInsets.symmetric(horizontal: 1),
        );

  const ToolbarButton.large(
      this.icon, {
        super.key,
      })  : text = null,
        iconSize = 19,
        super(
        width: 37,
        height: 28,
        padding: null,
        margin: const EdgeInsets.symmetric(horizontal: 1),
      );


  const ToolbarButton.text(
    this.text, {
    super.key,
  })  : icon = null,
        iconSize = null,
        super(
          width: 32,
          height: 32,
          padding: const EdgeInsets.only(bottom: 3),
          margin: const EdgeInsets.symmetric(horizontal: 1),
        );

  final String? text;
  final AssetIconData? icon;
  final double? iconSize;

  @override
  Widget buildContent(BuildContext context, Set<WidgetState> states) {
    return Center(
      child: icon != null && iconSize != null
          ? AssetIcon(icon!, size: iconSize, color: _foregroundColor)
          : Text(text!, style: _textStyle.copyWith(fontSize: 13)),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<AssetIconData?>('icon', icon));
    properties.add(DoubleProperty('iconSize', iconSize));
  }
}

class ToolbarDropdownButton extends BaseToolbarButton {
  const ToolbarDropdownButton({
    required this.icon,
    super.key,
    super.width = 39,
    super.height = 30,
    super.margin = const EdgeInsets.symmetric(horizontal: 1),
  }) : super(padding: const EdgeInsets.only(top: 2));

  final AssetIconData icon;

  @override
  Widget buildContent(BuildContext context, Set<WidgetState> states) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AssetIcon(icon, size: 19, color: _foregroundColor),
        const SizedBox(width: 3.71),
        const AssetIcon(
          SheetIcons.dropdown,
          width: 8,
          height: 4,
          color: _foregroundColor,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
  }
}

class ToolbarDropdownButtonSeparated extends ToolbarItem {
  const ToolbarDropdownButtonSeparated({
    required this.icon,
    this.width = 43,
    this.height = 30,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  final double width;
  final double height;
  final AssetIconData icon;
  final EdgeInsets margin;

  @override
  double get totalWidth => width + margin.horizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        children: <Widget>[
          _buildButtonPart(
            onTap: () {},
            child: AssetIcon(icon, size: 19, color: _foregroundColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
          ),
          _buildButtonPart(
            onTap: () {},
            child: const AssetIcon(
              SheetIcons.dropdown,
              width: 8,
              height: 4,
              color: _foregroundColor,
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            width: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonPart({
    required VoidCallback onTap,
    required Widget child,
    required BorderRadius borderRadius,
    double width = 30,
  }) {
    return MouseStateListener(
      onTap: onTap,
      childBuilder: (Set<WidgetState> states) {
        Color? backgroundColor = states.contains(WidgetState.hovered) ? _hoverColor : null;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
          ),
          child: Center(child: child),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
  }
}

class ToolbarColorPickerButton extends BaseToolbarButton {
  const ToolbarColorPickerButton({
    required this.icon,
    required this.color,
    super.key,
    super.width = 32,
    super.height = 30,
    super.margin = const EdgeInsets.symmetric(horizontal: 1),
  });

  final AssetIconData icon;
  final Color color;

  @override
  Widget buildContent(BuildContext context, Set<WidgetState> states) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Center(
          child: AssetIcon(icon, size: 19, color: _foregroundColor),
        ),
        Positioned(
          top: 20,
          left: 4.5,
          right: 4.5,
          child: Container(
            height: 4,
            decoration: BoxDecoration(color: color),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AssetIconData>('icon', icon));
    properties.add(ColorProperty('color', color));
  }
}

class ToolbarTextDropdownButton extends BaseToolbarButton {
  const ToolbarTextDropdownButton({
    required this.value,
    required super.width,
    super.key,
    super.height = 30,
    super.margin = const EdgeInsets.symmetric(horizontal: 1),
  }) : super(
          padding: const EdgeInsets.only(bottom: 1, left: 10, right: 10),
        );

  final String value;

  @override
  Widget buildContent(BuildContext context, Set<WidgetState> states) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            value,
            style: _textStyle.copyWith(fontSize: 15),
          ),
        ),
        const SizedBox(width: 3.71),
        const AssetIcon(
          SheetIcons.dropdown,
          width: 8,
          height: 4,
          color: _foregroundColor,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('value', value));
  }
}

class ToolbarTextField extends ToolbarItem {
  const ToolbarTextField({
    required this.value,
    this.width = 34,
    this.height = 24,
    this.margin = const EdgeInsets.symmetric(horizontal: 1),
    super.key,
  });

  final double width;
  final double height;
  final String value;
  final EdgeInsets margin;

  @override
  double get totalWidth => width + margin.horizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: Border.all(color: _foregroundColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          value,
          textAlign: TextAlign.center,
          overflow: TextOverflow.clip,
          style: _textStyle.copyWith(fontSize: 15),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('value', value));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
  }
}
