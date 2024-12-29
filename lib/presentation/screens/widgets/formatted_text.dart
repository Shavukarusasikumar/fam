import 'package:flutter/material.dart';

class FormattedText extends StatelessWidget {
  final dynamic formattedText;
  final TextStyle? style;

  const FormattedText({
    Key? key,
    required this.formattedText,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (formattedText is String) {
      return Text(formattedText, style: style);
    }

    if (formattedText is Map<String, dynamic>) {
      final entities = formattedText['entities'] as List?;
      if (entities?.isNotEmpty == true) {
        final entity = entities?.first;
        final text = entity['text'] ?? '';

        return Text(
          text,
          style: TextStyle(
            color: entity['color'] != null
                ? Color(int.parse(entity['color'].replaceAll('#', '0xFF')))
                : style?.color ?? Colors.black,
            fontSize: style?.fontSize ?? 16,
            fontWeight:
                entity['font_family']?.toString().contains('semi_bold') == true
                    ? FontWeight.w600
                    : style?.fontWeight ?? FontWeight.normal,
            fontFamily: 'Metropolis',
          ),
        );
      }
    }

    return const SizedBox(width: 1);
  }
}
