import 'package:fam/data/models/card_group.dart';

abstract class CardState {
  List<Object> get props => [];
}

class CardInitial extends CardState {}

class CardLoading extends CardState {}

class CardLoaded extends CardState {
  final List<CardGroup> cardGroups;
  CardLoaded(this.cardGroups);

  @override
  List<Object> get props => [cardGroups];
}

class CardError extends CardState {
  final String message;
  CardError(this.message);

  @override
  List<Object> get props => [message];
}
