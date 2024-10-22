part of 'keyboard_listener.dart';

abstract class KeyboardState with EquatableMixin {
  const KeyboardState();

  KeyboardState _addKey(LogicalKeyboardKey key);

  KeyboardState _removeKey(LogicalKeyboardKey key);

  bool get anyKeyActive;

  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey);

  bool areKeysPressed(List<LogicalKeyboardKey> keys);

  bool containsState(KeyboardState other) {
    return other.keyIds.every((int keyId) => keyIds.contains(keyId));
  }

  List<LogicalKeyboardKey> get keys;

  List<int> get keyIds;
}

class NoKeysPressedState extends KeyboardState {
  const NoKeysPressedState();

  @override
  bool get anyKeyActive => false;

  @override
  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) => false;

  @override
  bool areKeysPressed(List<LogicalKeyboardKey> keys) => false;

  @override
  bool containsState(KeyboardState other) => other is NoKeysPressedState;

  @override
  List<int> get keyIds => <int>[];

  @override
  List<LogicalKeyboardKey> get keys => <LogicalKeyboardKey>[];

  @override
  KeyboardState _addKey(LogicalKeyboardKey key) {
    return SingleKeyPressedState(key);
  }

  @override
  KeyboardState _removeKey(LogicalKeyboardKey key) {
    throw StateError('Trying to remove key from NoKeysPressedState');
  }

  @override
  List<Object?> get props => <Object>[];
}

class SingleKeyPressedState extends KeyboardState {
  final LogicalKeyboardKey key;

  const SingleKeyPressedState(this.key);

  @override
  bool get anyKeyActive => true;

  @override
  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) => key.keyId == logicalKeyboardKey.keyId;

  @override
  bool areKeysPressed(List<LogicalKeyboardKey> keys) => keys.map((LogicalKeyboardKey key) => key.keyId).contains(key.keyId);

  @override
  List<int> get keyIds => <int>[key.keyId];

  @override
  List<LogicalKeyboardKey> get keys => <LogicalKeyboardKey>[key];

  @override
  KeyboardState _addKey(LogicalKeyboardKey key) {
    return MultiKeysPressedState(<LogicalKeyboardKey>[this.key, key]);
  }

  @override
  KeyboardState _removeKey(LogicalKeyboardKey key) {
    if (isKeyPressed(key)) {
      return const NoKeysPressedState();
    }
    throw StateError('Trying to remove non-existing key from SingleKeyPressedState');
  }

  @override
  List<Object?> get props => <Object>[key];
}

class MultiKeysPressedState extends KeyboardState {
  final List<LogicalKeyboardKey> _keys;

  const MultiKeysPressedState(this._keys);

  @override
  bool get anyKeyActive => true;

  @override
  bool isKeyPressed(LogicalKeyboardKey logicalKeyboardKey) {
    return keys.map((LogicalKeyboardKey key) => key.keyId).contains(logicalKeyboardKey.keyId);
  }

  @override
  bool areKeysPressed(List<LogicalKeyboardKey> keys) {
    return keys.every((LogicalKeyboardKey key) => isKeyPressed(key));
  }

  @override
  List<int> get keyIds => _keys.map((LogicalKeyboardKey key) => key.keyId).toList();

  @override
  List<LogicalKeyboardKey> get keys => _keys;

  @override
  KeyboardState _addKey(LogicalKeyboardKey key) {
    if (!isKeyPressed(key)) {
      keys.add(key);
    }
    return this;
  }

  @override
  KeyboardState _removeKey(LogicalKeyboardKey key) {
    if (!isKeyPressed(key)) {
      throw StateError('Trying to remove non-existing key from MultiKeysPressedState');
    }
    keys.removeWhere((LogicalKeyboardKey previous) => previous.keyId == key.keyId);
    if (keys.isEmpty) {
      return const NoKeysPressedState();
    } else if (keys.length == 1) {
      return SingleKeyPressedState(keys.first);
    } else {
      return this;
    }
  }

  @override
  List<Object?> get props => <Object>[keys];
}
