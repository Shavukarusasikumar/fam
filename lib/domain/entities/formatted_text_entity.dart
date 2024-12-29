class FormattedTextEntity {
  final String text;
  final String type;
  final String? color;
  final double? fontSize;
  final String? fontStyle;
  final String? fontFamily;
  final String? align;

  FormattedTextEntity({
    required this.text,
    required this.type,
    this.color,
    this.fontSize,
    this.fontStyle,
    this.fontFamily,
    this.align,
  });
}

class FormattedTextData {
  final String text;
  final String? align;
  final List<FormattedTextEntity> entities;

  FormattedTextData({
    required this.text,
    this.align,
    required this.entities,
  });
}
