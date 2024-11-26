import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle join(TextStyle? other) {
    if (other == null) {
      return this;
    }

    TextStyle emptyTextStyle = const TextStyle();

    return TextStyle(
      color: other.color != emptyTextStyle.color ? other.color : color,
      backgroundColor: other.backgroundColor != emptyTextStyle.backgroundColor ? other.backgroundColor : backgroundColor,
      fontSize: other.fontSize != emptyTextStyle.fontSize ? other.fontSize : fontSize,
      fontWeight: other.fontWeight != emptyTextStyle.fontWeight ? other.fontWeight : fontWeight,
      fontStyle: other.fontStyle != emptyTextStyle.fontStyle ? other.fontStyle : fontStyle,
      letterSpacing: other.letterSpacing != emptyTextStyle.letterSpacing ? other.letterSpacing : letterSpacing,
      wordSpacing: other.wordSpacing != emptyTextStyle.wordSpacing ? other.wordSpacing : wordSpacing,
      textBaseline: other.textBaseline != emptyTextStyle.textBaseline ? other.textBaseline : textBaseline,
      height: other.height != emptyTextStyle.height ? other.height : height,
      locale: other.locale != emptyTextStyle.locale ? other.locale : locale,
      foreground: other.foreground != emptyTextStyle.foreground ? other.foreground : foreground,
      background: other.background != emptyTextStyle.background ? other.background : background,
      shadows: other.shadows != emptyTextStyle.shadows ? other.shadows : shadows,
      fontFeatures: other.fontFeatures != emptyTextStyle.fontFeatures ? other.fontFeatures : fontFeatures,
      decoration: other.decoration != emptyTextStyle.decoration ? other.decoration : decoration,
      decorationColor: other.decorationColor != emptyTextStyle.decorationColor ? other.decorationColor : decorationColor,
      decorationStyle: other.decorationStyle != emptyTextStyle.decorationStyle ? other.decorationStyle : decorationStyle,
      decorationThickness:
          other.decorationThickness != emptyTextStyle.decorationThickness ? other.decorationThickness : decorationThickness,
      debugLabel: other.debugLabel != emptyTextStyle.debugLabel ? other.debugLabel : debugLabel,
      fontFamily: other.fontFamily != emptyTextStyle.fontFamily ? other.fontFamily : fontFamily,
      fontFamilyFallback:
          other.fontFamilyFallback != emptyTextStyle.fontFamilyFallback ? other.fontFamilyFallback : fontFamilyFallback,
    );
  }
}
