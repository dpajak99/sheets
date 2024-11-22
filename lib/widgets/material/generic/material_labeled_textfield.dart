import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialLabeledTextField extends StatelessWidget {
  const MaterialLabeledTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required double width,
    double? textFieldWidth,
    List<TextInputFormatter>? formatters,
    ValueChanged<String>? onChanged,
    super.key,
  }) : _controller = controller,
       _focusNode = focusNode,
       _label = label,
       _width = width,
       _textFieldWidth = textFieldWidth ?? width,
       _formatters = formatters,
       _onChanged = onChanged;

  final TextEditingController _controller;
  final FocusNode _focusNode;
  final String _label;
  final double _width;
  final double _textFieldWidth;
  final List<TextInputFormatter> ?_formatters;
  final ValueChanged<String>? _onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xff606368),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: _textFieldWidth,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xff3d4043),
                letterSpacing: -0.3,
              ),
              inputFormatters: _formatters,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDADCE0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffDADCE0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}