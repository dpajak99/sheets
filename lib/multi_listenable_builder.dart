import 'package:flutter/cupertino.dart';

class MultiListenableBuilder extends StatefulWidget {
  final List<Listenable> listenables;
  final Widget Function(BuildContext context) builder;

  const MultiListenableBuilder({
    required this.listenables,
    required this.builder,
    super.key,
  });

  @override
  State<MultiListenableBuilder> createState() => _MultiListenableBuilderState();
}

class _MultiListenableBuilderState extends State<MultiListenableBuilder> {
  @override
  void initState() {
    super.initState();
    for (Listenable listenable in widget.listenables) {
      listenable.addListener(_listener);
    }
  }

  @override
  void dispose() {
    for (Listenable listenable in widget.listenables) {
      listenable.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void _listener() {
    setState(() {});
  }
}