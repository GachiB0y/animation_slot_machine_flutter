import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class SlotMachineViewState extends Equatable {
  final int rate = 10;
  final int currentBalance;
  final int bet;
  bool jackpot = false;
  bool isNotRunAnimation = true;
  final Random random = Random();
  final List<int> index;

  SlotMachineViewState({
    required this.currentBalance,
    required this.bet,
    required this.jackpot,
    required this.isNotRunAnimation,
    required this.index,
  });

  SlotMachineViewState copyWith({
    int? currentBalance,
    int? bet,
    bool? jackpot,
    bool? isRunAnimation,
    List<int>? index,
  }) {
    return SlotMachineViewState(
      currentBalance: currentBalance ?? this.currentBalance,
      bet: bet ?? this.bet,
      jackpot: jackpot ?? this.jackpot,
      isNotRunAnimation: isRunAnimation ?? this.isNotRunAnimation,
      index: index ?? this.index,
    );
  }

  @override
  bool operator ==(covariant SlotMachineViewState other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.currentBalance == currentBalance &&
        other.bet == bet &&
        other.jackpot == jackpot &&
        other.isNotRunAnimation == isNotRunAnimation &&
        listEquals(other.index, index);
  }

  @override
  int get hashCode {
    return currentBalance.hashCode ^
        bet.hashCode ^
        jackpot.hashCode ^
        isNotRunAnimation.hashCode ^
        index.hashCode;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [currentBalance,bet,jackpot,isNotRunAnimation,index];
}

class SlotMachineCubit extends Cubit<SlotMachineViewState> {
  SlotMachineCubit()
      : super(SlotMachineViewState(
            currentBalance: 0,
            bet: 0,
            jackpot: false,
            index: [1, 1, 1],
            isNotRunAnimation: true)) {}

  void incrementBalanceWithWin() {
    var balance = state.currentBalance;
    var bet = state.bet;
    var rate = state.rate;
    balance = balance + (bet * rate);
    final newState = state.copyWith(currentBalance: balance);
    emit(newState);
  }

  void decrementBalanceWithLoose() {
    var balance = state.currentBalance;
    var bet = state.bet;
    balance = balance - bet;
    final newState = state.copyWith(currentBalance: balance);
    emit(newState);
  }

  void changeBet(String betValue) {
    var balance = state.currentBalance;
    var bet = state.bet;
    int? betIntValue = int.tryParse(betValue);
    if (betIntValue != null) {
      bet = betIntValue;
      if (bet <= balance && bet >= 0) {
        final newState = state.copyWith(bet: bet);
        emit(newState);
      }
    }
  }

  void topUpBalance(String balanceValue) {
    var balance = state.currentBalance;
    int? balanceIntValue = int.tryParse(balanceValue);
    if (balanceIntValue != null && balanceIntValue >= 0) {
      balance = balanceIntValue;
      final newState = state.copyWith(currentBalance: balance);
      emit(newState);
    }
  }

  void winOrLoose(BuildContext context) {
    final List<int> indexValue = state.index;
    final bool jackpotValue = state.jackpot;

    if (indexValue[0] == indexValue[1] && indexValue[1] == indexValue[2]) {
      changeJackpot();
      print('JACK: $jackpotValue');
      incrementBalanceWithWin();
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Внимание!'),
          content: const Text('Вы выиграли!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                changeIsAnimationRun();
                changeJackpot();
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      changeIsAnimationRun();
      decrementBalanceWithLoose();
    }
  }

  void changeJackpot() {
    final bool jackpotValue = state.jackpot;
    final newState = state.copyWith(jackpot: !jackpotValue);
    emit(newState);
  }

  void changeIsAnimationRun() {
    final bool IsAnimationRun = state.isNotRunAnimation;
    final newState = state.copyWith(isRunAnimation: !IsAnimationRun);
    emit(newState);
  }

  void changeIndex() {
    final List<int> indexValue = state.index;
    final Random randomValue = state.random;
    final List<int> listIndex = [
      randomValue.nextInt(3),
      randomValue.nextInt(3),
      randomValue.nextInt(3)
    ];
    final newState = state.copyWith(index: listIndex);
    emit(newState);
  }
}
