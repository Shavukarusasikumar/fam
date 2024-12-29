import 'package:fam/data/models/card_group.dart';
import 'package:fam/presentation/screens/home/widgets/big_display_card.dart';
import 'package:fam/presentation/screens/home/widgets/dynamic_width_card.dart';
import 'package:fam/presentation/screens/home/widgets/image_card.dart';
import 'package:fam/presentation/screens/home/widgets/small_card_with_arrow.dart';
import 'package:fam/presentation/screens/home/widgets/small_display_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardGroupWidget extends StatelessWidget {
  final CardGroup cardGroup;
  final SharedPreferences prefs;

  const CardGroupWidget({
    super.key,
    required this.cardGroup,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    if (cardGroup.cards.isEmpty) {
      return const SizedBox();
    }

    switch (cardGroup.designType) {
      case "HC3":
        return cardGroup.cards.isNotEmpty
            ? BigDisplayCard(card: cardGroup.cards.first)
            : const SizedBox();
      case "HC6":
        return cardGroup.cards.isNotEmpty
            ? SmallCardWithArrow(card: cardGroup.cards.first)
            : const SizedBox();
      case "HC5":
        return cardGroup.cards.isNotEmpty
            ? ImageCard(card: cardGroup.cards.first)
            : const SizedBox();
      case "HC9":
        return cardGroup.cards.isNotEmpty
            ? DynamicWidthCard(
                cards: cardGroup.cards,
                height: cardGroup.height.toDouble(),
              )
            : const SizedBox();
      case "HC1":
        return SmallDisplayCard(
          cards: cardGroup.cards,
          isScrollable: cardGroup.isScrollable,
          prefs: prefs,
        );
      default:
        return const SizedBox();
    }
  }
}
