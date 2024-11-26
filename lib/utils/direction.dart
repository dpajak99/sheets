enum Direction {
  top,
  right,
  bottom,
  left;

  bool get isVertical => this == Direction.top || this == Direction.bottom;

  bool get isHorizontal => this == Direction.left || this == Direction.right;

  /// Returns the opposite direction.
  Direction get opposite {
    switch (this) {
      case Direction.top:
        return Direction.bottom;
      case Direction.right:
        return Direction.left;
      case Direction.bottom:
        return Direction.top;
      case Direction.left:
        return Direction.right;
    }
  }

  /// Rotates the direction 90 degrees clockwise.
  Direction get rotateClockwise {
    switch (this) {
      case Direction.top:
        return Direction.right;
      case Direction.right:
        return Direction.bottom;
      case Direction.bottom:
        return Direction.left;
      case Direction.left:
        return Direction.top;
    }
  }

  /// Rotates the direction 90 degrees counterclockwise.
  Direction get rotateCounterClockwise {
    switch (this) {
      case Direction.top:
        return Direction.left;
      case Direction.right:
        return Direction.top;
      case Direction.bottom:
        return Direction.right;
      case Direction.left:
        return Direction.bottom;
    }
  }
}
