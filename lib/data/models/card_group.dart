import 'package:fam/data/models/crad_item.dart';

class CardGroup {
  final String designType;
  final bool isScrollable;
  final int height;
  final List<CardItem> cards;

  CardGroup({
    required this.designType,
    required this.isScrollable,
    required this.height,
    required this.cards,
  });
}

