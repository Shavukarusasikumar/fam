abstract class CardEvent {
  List<Object> get props => [];
}

class LoadCards extends CardEvent {}

class RemindLaterCard extends CardEvent {
  final String cardId;
  RemindLaterCard(this.cardId);

  @override
  List<Object> get props => [cardId];
}

class DismissCard extends CardEvent {
  final String cardId;
  DismissCard(this.cardId);

  @override
  List<Object> get props => [cardId];
}
