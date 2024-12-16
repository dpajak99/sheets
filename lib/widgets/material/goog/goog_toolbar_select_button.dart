import 'package:flutter/material.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';
import 'package:sheets/widgets/material/goog/goog_icon.dart';
import 'package:sheets/widgets/material/goog/goog_text.dart';
import 'package:sheets/widgets/material/goog/goog_toolbar_button.dart';
import 'package:sheets/widgets/static_size_widget.dart';
import 'package:sheets/widgets/widget_state_builder.dart';

typedef GoogToolbarSelectValueParser<T> = String Function(T value);

class GoogToolbarSelectButton<T> extends StatelessWidget implements StaticSizeWidget {
  GoogToolbarSelectButton({
    required T selectedValue,
    required GoogToolbarSelectValueParser<T> valueParser,
    required double width,
    required double height,
    VoidCallback? onTap,
    bool? disabled,
    GoogToolbarButtonStyle? style,
    EdgeInsets? margin,
    EdgeInsets? padding,
    super.key,
  })  : _selectedValue = selectedValue,
        _valueParser = valueParser,
        _width = width,
        _height = height,
        _onTap = onTap,
        _disabled = disabled ?? false,
        _style = style ?? GoogToolbarButtonStyle.defaultStyle(),
        _margin = margin ?? const EdgeInsets.all(1),
        _padding = padding ?? const EdgeInsets.symmetric(horizontal: 11);

  final T _selectedValue;
  final GoogToolbarSelectValueParser<T> _valueParser;
  final double _width;
  final double _height;
  final VoidCallback? _onTap;
  final bool _disabled;
  final GoogToolbarButtonStyle _style;
  final EdgeInsets _margin;
  final EdgeInsets _padding;

  @override
  EdgeInsets get margin => _margin;

  @override
  Size get size => Size(_width, _height);

  @override
  Widget build(BuildContext context) {
    return WidgetStateBuilder(
      onTap: _onTap,
      disabled: _disabled,
      cursor: SystemMouseCursors.click,
      builder: (Set<WidgetState> states) {
        Color backgroundColor = _style.backgroundColor.resolve(states);
        Color foregroundColor = _style.foregroundColor.resolve(states);

        return Container(
          width: _width,
          height: _height,
          margin: _margin,
          padding: _padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GoogTextTheme(
                    fontFamily: 'GoogleSans',
                    package: 'sheets',
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: foregroundColor,
                    child: GoogText(_valueParser(_selectedValue)),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              AssetIcon(
                SheetIcons.docs_icon_arrow_dropdown,
                width: 8,
                height: 4,
                color: foregroundColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
