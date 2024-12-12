import 'package:flutter/material.dart';

typedef PopupBuilder = Widget Function(BuildContext context);

/// A class responsible for managing overlay popups.
/// It provides static methods to open and close popups globally.
class SheetPopup {
  // Keeps track of currently open popups by level.
  static final Map<int, OverlayEntry> _currentlyOpenGlobalPopups = {};

  /// Opens a global popup at the specified [level] and [offset] using the provided [popupBuilder].
  /// This will close all popups at the same or higher levels before opening the new one.
  static void openGlobalPopup(
    BuildContext context,
    int level,
    Offset offset,
    PopupBuilder popupBuilder,
  ) {
    // Close existing popups at the same or higher levels.
    _closePopupsAtOrAboveLevel(level);

    // Create a new OverlayEntry with the SheetPopupOverlay widget.
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return SheetPopupOverlay(
          offset: offset,
          popupContent: popupBuilder(context),
          onDismiss: () {
            closeGlobalPopup(level);
          },
        );
      },
    );

    // Insert the OverlayEntry into the Overlay.
    Overlay.of(context).insert(overlayEntry);

    // Register the open popup.
    _currentlyOpenGlobalPopups[level] = overlayEntry;
  }

  /// Closes all global popups at the specified [level] and above.
  static void closeGlobalPopupsAtOrAboveLevel(int level) {
    _closePopupsAtOrAboveLevel(level);
  }

  /// Internal method to close popups at or above a certain [level].
  static void _closePopupsAtOrAboveLevel(int level) {
    final levelsToClose = _currentlyOpenGlobalPopups.keys.where((l) => l >= level).toList(); // To avoid concurrent modification

    for (final l in levelsToClose) {
      _currentlyOpenGlobalPopups[l]?.remove();
      _currentlyOpenGlobalPopups.remove(l);
    }
  }

  /// Closes a specific global popup at the given [level].
  static void closeGlobalPopup(int level) {
    if (_currentlyOpenGlobalPopups.containsKey(level)) {
      _currentlyOpenGlobalPopups[level]?.remove();
      _currentlyOpenGlobalPopups.remove(level);
    }
  }
}

/// A widget that represents the overlay content of the popup.
/// It includes listeners to detect taps outside the popup to dismiss it.
class SheetPopupOverlay extends StatelessWidget {
  const SheetPopupOverlay({
    required this.offset,
    required this.popupContent,
    required this.onDismiss,
    Key? key,
  }) : super(key: key);

  final Offset offset;
  final Widget popupContent;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Detect taps outside the popup
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
            child: Container(),
          ),
        ),
        // Popup Positioned at the specified offset
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: popupContent,
        ),
      ],
    );
  }
}
