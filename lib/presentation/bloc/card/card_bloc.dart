import 'package:fam/data/models/card_group.dart';
import 'package:fam/data/repositories/card_repository.dart';
import 'package:fam/presentation/bloc/card/card_event.dart';
import 'package:fam/presentation/bloc/card/card_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository repository;
  final SharedPreferences prefs;

  CardBloc({
    required this.repository,
    required this.prefs,
  }) : super(CardInitial()) {
    on<LoadCards>(_onLoadCards);
    on<RemindLaterCard>(_onRemindLaterCard);
    on<DismissCard>(_onDismissCard);
  }

  void _onLoadCards(LoadCards event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      final cardGroups = await repository.fetchCards();
      emit(CardLoaded(cardGroups));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }

  Future<void> _onRemindLaterCard(
      RemindLaterCard event, Emitter<CardState> emit) async {
    if (state is CardLoaded) {
      final currentState = state as CardLoaded;

      await prefs.setString(
          'remind_later_${event.cardId}', DateTime.now().toIso8601String());

      final updatedGroups = currentState.cardGroups
          .map((group) {
            return CardGroup(
              designType: group.designType,
              isScrollable: group.isScrollable,
              height: group.height,
              cards:
                  group.cards.where((card) => card.id != event.cardId).toList(),
            );
          })
          .where((group) => group.cards.isNotEmpty)
          .toList();

      emit(CardLoaded(updatedGroups));
      Fluttertoast.showToast(
        msg: "Card set to remind later!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _onDismissCard(
      DismissCard event, Emitter<CardState> emit) async {
    if (state is CardLoaded) {
      final currentState = state as CardLoaded;

      await prefs.setString('dismissed_${event.cardId}', 'true');

      final updatedGroups = currentState.cardGroups
          .map((group) {
            return CardGroup(
              designType: group.designType,
              isScrollable: group.isScrollable,
              height: group.height,
              cards:
                  group.cards.where((card) => card.id != event.cardId).toList(),
            );
          })
          .where((group) => group.cards.isNotEmpty)
          .toList();

      emit(CardLoaded(updatedGroups));
      Fluttertoast.showToast(
        
        msg: "Card dismissed!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
      );
    }
  }
}
