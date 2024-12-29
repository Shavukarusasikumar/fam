import '../../data/models/card_group.dart';

abstract class CardRepository {
  Future<List<CardGroup>> fetchCards();
}