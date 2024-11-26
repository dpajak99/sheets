enum BorderEdge {
  top,
  right,
  bottom,
  left;

  BorderEdge get opposite {
    switch (this) {
      case BorderEdge.top:
        return BorderEdge.bottom;
      case BorderEdge.right:
        return BorderEdge.left;
      case BorderEdge.bottom:
        return BorderEdge.top;
      case BorderEdge.left:
        return BorderEdge.right;
    }
  }
}
