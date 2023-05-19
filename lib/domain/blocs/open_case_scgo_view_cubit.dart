import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenCaseViewState {
  final int countItem;
  final double widthDivider;
  final double widthOneItem;
  List<String> _listItems = [];
  List<String> get items => _listItems;

  final Random random = Random();
  OpenCaseViewState({
    required this.countItem,
    required this.widthDivider,
    required this.widthOneItem,
    required List<String> listItems,
  }) : _listItems = listItems;

  OpenCaseViewState copyWith({
    int? countItem,
    double? widthDivider,
    double? widthOneItem,
    List<String>? listItems,
  }) {
    return OpenCaseViewState(
      countItem: countItem ?? this.countItem,
      widthDivider: widthDivider ?? this.widthDivider,
      widthOneItem: widthOneItem ?? this.widthOneItem,
      listItems: listItems ?? this._listItems,
    );
  }

  @override
  bool operator ==(covariant OpenCaseViewState other) {
    if (identical(this, other)) return true;

    return other.countItem == countItem &&
        other.widthDivider == widthDivider &&
        other.widthOneItem == widthOneItem &&
        listEquals(other._listItems, _listItems);
  }

  @override
  int get hashCode {
    return countItem.hashCode ^
        widthDivider.hashCode ^
        widthOneItem.hashCode ^
        _listItems.hashCode;
  }
}

class OpenCaseCubit extends Cubit<OpenCaseViewState> {
  OpenCaseCubit()
      : super(OpenCaseViewState(
            countItem: 100,
            widthDivider: 5.0,
            widthOneItem: 100,
            listItems: [])) {
    createListItems();
  }

  void startState(ScrollController controller) {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void createListItems() {
    final newCountItems = state.countItem;
    final newRandom = state.random;
    final List<String> newListItems = [];
    for (var i = 1; i < newCountItems + 1; i++) {
      final int itemIndex = newRandom.nextInt(20) + 1;
      final String nameIamges = "assets/images/${itemIndex.toString()}.jpg";
      newListItems.add(nameIamges);
    }
    final newState = state.copyWith(listItems: newListItems);
    emit(newState);
  }

  void alertDialog(
      BuildContext context, int selectItem, ScrollController controller) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Вы получили следующий приз!'),
        content: Image.asset(state._listItems[selectItem],
            width: state.widthOneItem, height: state.widthOneItem),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final List<String> newListItems = [];
              startState(controller);
              final newState = state.copyWith(listItems: newListItems);
              emit(newState);
              createListItems();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void animateToIndex(
      BuildContext context, int index, ScrollController controller) {
    final mediaQuery = MediaQuery.of(context);
    final widthScreen = mediaQuery.size.width;
    final halfScreen = widthScreen / 2;
    final wayAll = index * (state.widthOneItem + state.widthDivider);
    final countHalfScreen = (wayAll / (widthScreen / 2)).roundToDouble();
    final wayScreen = countHalfScreen * (widthScreen / 2);
    late final double wayFact;
    if (wayAll < wayScreen) {
      final delta = wayScreen - wayAll;
      wayFact = wayAll -
          (halfScreen - delta) -
          ((state.widthOneItem + state.widthDivider) / 2);
    } else if (wayAll > wayScreen) {
      final delta = wayAll - wayScreen;
      wayFact = wayAll -
          (halfScreen - delta) -
          ((state.widthOneItem + state.widthDivider) / 2);
    } else {
      wayFact =
          wayAll - (halfScreen - (state.widthOneItem + state.widthDivider) / 2);
    }
    print(
        "wayAll:${wayAll} -- wayScreen:${wayScreen} -- countHalfScreen:${countHalfScreen} -- widthScreen:${widthScreen}");
    controller.animateTo(
      wayFact,
      duration: const Duration(seconds: 5),
      curve: Curves.fastOutSlowIn,
    );
  }
}
