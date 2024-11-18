enum Direction {
  top,
  right,
  bottom,
  left;

  bool get isVertical => this == Direction.top || this == Direction.bottom;
  bool get isHorizontal => this == Direction.left || this == Direction.right;
}
