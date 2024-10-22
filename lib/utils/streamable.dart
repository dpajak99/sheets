import 'dart:async';

class Streamable<T> {
  Streamable() {
    _streamController = StreamController<T>();
  }

  late final StreamController<T> _streamController;

  void listen(void Function(T) onData) {
    _streamController.stream.listen(onData);
  }

  Future<void> dispose() async {
    await _streamController.close();
  }

  void addEvent(T event) {
    _streamController.add(event);
  }

  Stream<T> get stream => _streamController.stream;
}
