abstract class StyleFormatIntent {}

abstract class StyleFormatAction<I extends StyleFormatIntent> {
  StyleFormatAction({required this.intent});

  final I intent;
}
