import 'dart:convert';

import 'package:fam/core/constants/api_constants.dart';
import 'package:fam/data/models/card_cta.dart';
import 'package:fam/data/models/card_group.dart';
import 'package:fam/data/models/crad_item.dart';
import 'package:fam/data/repositories/card_repository.dart';
import 'package:fam/domain/entities/formatted_text_entity.dart';
import 'package:http/http.dart' as http;

class CardRepositoryImpl implements CardRepository {
  final http.Client client;

  CardRepositoryImpl({required this.client});

  @override
  Future<List<CardGroup>> fetchCards() async {
    try {
      final response = await client.get(Uri.parse(ApiConstants.cardsUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to load cards');
      }

      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isEmpty) return [];

      final hcGroups = jsonData[0]['hc_groups'] as List<dynamic>;

      return hcGroups.map((group) {
        return CardGroup(
          designType: group['design_type'],
          isScrollable: group['is_scrollable'] ?? false,
          height: group['height'] ?? 0,
          cards: _transformCards(group['cards'] as List<dynamic>),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error processing data: ${e.toString()}');
    }
  }

  List<CardItem> _transformCards(List<dynamic> cards) {
    return cards.map((card) {
      FormattedTextData? formattedTitle;

      if (card['formatted_title'] != null) {
        final entities = (card['formatted_title']['entities'] as List?)
                ?.map((entity) => FormattedTextEntity(
                      text: entity['text'] ?? '',
                      type: entity['type'] ?? 'generic_text',
                      color: entity['color'],
                      fontSize: entity['font_size']?.toDouble(),
                      fontStyle: entity['font_style'],
                      fontFamily: entity['font_family'],
                    ))
                .toList() ??
            [];

        formattedTitle = FormattedTextData(
          text: card['formatted_title']['text'] ?? '',
          align: card['formatted_title']['align'],
          entities: entities,
        );
      }

      return CardItem(
        id: card['id'].toString(),
        title: card['title'] ?? '',
        formattedTitle: formattedTitle,
        description: _extractDescription(card),
        bgImage: card['bg_image']?['image_url'],
        bgColor: card['bg_color'],
        gradientColors: card['bg_gradient']?['colors']?.cast<String>(),
        icon: card['icon']?['image_url'],
        url: card['url'],
        cta: _transformCTA(card['cta'] as List?),
      );
    }).toList();
  }

  String _extractDescription(dynamic card) {
    if (card['formatted_description'] != null) {
      final entities = card['formatted_description']['entities'] as List?;
      if (entities != null && entities.isNotEmpty) {
        return entities.map((entity) => entity['text'] ?? '').join('\n');
      }
    }
    return card['description'] ?? '';
  }

  List<CardCTA>? _transformCTA(List? ctaList) {
    if (ctaList == null) return null;

    return ctaList.map((cta) {
      return CardCTA(
        text: cta['text'],
        bgColor: cta['bg_color'],
        textColor: cta['text_color'],
        url: cta['url'],
      );
    }).toList();
  }
}
