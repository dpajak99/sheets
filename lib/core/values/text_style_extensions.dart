import 'package:flutter/material.dart';

extension TextStyleExtensions on Iterable<TextStyle> {
  TextStyle getSharedStyle() {
    List<TextStyle> styles = toList();
    if (styles.isEmpty) {
      return const TextStyle();
    }

    Color? color = styles.first.color;
    TextDecoration? decoration = styles.first.decoration;
    Color? decorationColor = styles.first.decorationColor;
    TextDecorationStyle? decorationStyle  = styles.first.decorationStyle;
    double? decorationThickness = styles.first.decorationThickness;
    FontWeight? fontWeight = styles.first.fontWeight;
    FontStyle? fontStyle = styles.first.fontStyle;
    TextBaseline? textBaseline = styles.first.textBaseline;
    String? fontFamily = styles.first.fontFamily;
    List<String>? fontFamilyFallback = styles.first.fontFamilyFallback;
    double? fontSize = styles.first.fontSize;
    double? letterSpacing = styles.first.letterSpacing;
    double? wordSpacing = styles.first.wordSpacing;
    double? height  = styles.first.height;
    TextLeadingDistribution? leadingDistribution  = styles.first.leadingDistribution;
    Locale? locale  = styles.first.locale;
    Paint? background = styles.first.background;
    Paint? foreground = styles.first.foreground;
    List<Shadow>? shadows = styles.first.shadows;
    List<FontFeature>? fontFeatures = styles.first.fontFeatures;
    List<FontVariation>? fontVariations = styles.first.fontVariations;

    styles.removeAt(0);

    for (TextStyle style in styles) {
      color = color != null && color == style.color ? color : null;
      decoration = decoration != null && decoration == style.decoration ? decoration : null;
      decorationColor = decorationColor != null && decorationColor == style.decorationColor ? decorationColor : null;
      decorationStyle = decorationStyle != null && decorationStyle == style.decorationStyle ? decorationStyle : null;
      decorationThickness = decorationThickness != null && decorationThickness == style.decorationThickness ? decorationThickness : null;
      fontWeight = fontWeight != null && fontWeight == style.fontWeight ? fontWeight : null;
      fontStyle = fontStyle != null && fontStyle == style.fontStyle ? fontStyle : null;
      textBaseline = textBaseline != null && textBaseline == style.textBaseline ? textBaseline : null;
      fontFamily = fontFamily != null && fontFamily == style.fontFamily ? fontFamily : null;
      fontFamilyFallback = fontFamilyFallback != null && fontFamilyFallback == style.fontFamilyFallback ? fontFamilyFallback : null;
      fontSize = fontSize != null && fontSize == style.fontSize ? fontSize : null;
      letterSpacing = letterSpacing != null && letterSpacing == style.letterSpacing ? letterSpacing : null;
      wordSpacing = wordSpacing != null && wordSpacing == style.wordSpacing ? wordSpacing : null;
      height = height != null && height == style.height ? height : null;
      leadingDistribution = leadingDistribution != null && leadingDistribution == style.leadingDistribution ? leadingDistribution : null;
      locale = locale != null && locale == style.locale ? locale : null;
      background = background != null && background == style.background ? background : null;
      foreground = foreground != null && foreground == style.foreground ? foreground : null;
      shadows = shadows != null && shadows == style.shadows ? shadows : null;
      fontFeatures = fontFeatures != null && fontFeatures == style.fontFeatures ? fontFeatures : null;
      fontVariations = fontVariations != null && fontVariations == style.fontVariations ? fontVariations : null;
    }
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      textBaseline: textBaseline,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );
  }
}
