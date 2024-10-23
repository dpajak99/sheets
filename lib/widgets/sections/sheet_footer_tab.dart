import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheets/core/config/app_icons/asset_icon.dart';

class SheetFooterTab extends StatelessWidget {
  const SheetFooterTab({
    required this.title,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String title;
  final bool selected;
  final VoidCallback onPressed;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<bool>('selected', selected));
    properties.add(StringProperty('title', title));
  }

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = selected ? const Color(0xffE1E9F7) : null;
    Color foregroundColor = Color(selected ? 0xff0B57D0 : 444746);

    return Container(
      width: 91,
      height: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      padding: const EdgeInsets.only(left: 10, right: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 19.5, color: foregroundColor),
        ],
      ),
    );
  }
}
