import 'package:fam/domain/entities/formatted_text_entity.dart';
import 'package:fam/data/models/card_cta.dart';

class CardItem {
  final String id;
  final String title;
  final FormattedTextData? formattedTitle;
  final String? description;
  final String? bgImage;
  final String? bgColor;
  final List<String>? gradientColors;
  final String? icon;
  final List<CardCTA>? cta;
  final String? url;

  CardItem({
    required this.id,
    required this.title,
    this.formattedTitle,
    this.description,
    this.bgImage,
    this.bgColor,
    this.gradientColors,
    this.icon,
    this.cta,
    this.url,
  });
}
