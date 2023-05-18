import 'dart:math';

import 'package:flutter/material.dart';

class OpenCaseCsGoWidget extends StatefulWidget {
  OpenCaseCsGoWidget({super.key});

  @override
  State<OpenCaseCsGoWidget> createState() => _OpenCaseCsGoWidgetState();
}

class _OpenCaseCsGoWidgetState extends State<OpenCaseCsGoWidget> {
  final ScrollController _controller = ScrollController();
  final int countItem = 100;
  static const double widthDivider = 5.0;
  final double _widthOneItem = 105.0;
  List<String> listItems = [];

  final Random random = Random();

  void startState() {
    _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void _animateToIndex(BuildContext context, int index) {
    final mediaQuery = MediaQuery.of(context);
    final widthScreen = mediaQuery.size.width;
    final halfScreen = widthScreen / 2;
    final wayAll = index * (_widthOneItem + widthDivider);
    final countHalfScreen = (wayAll / (widthScreen / 2)).roundToDouble();
    final wayScreen = countHalfScreen * (widthScreen / 2);
    late final double wayFact;
    if (wayAll < wayScreen) {
      final delta = wayScreen - wayAll;
      wayFact =
          wayAll - (halfScreen - delta) - ((_widthOneItem + widthDivider) / 2);
    } else if (wayAll > wayScreen) {
      final delta = wayAll - wayScreen;
      wayFact =
          wayAll - (halfScreen - delta) - ((_widthOneItem + widthDivider) / 2);
    } else {
      wayFact = wayAll - (halfScreen - (_widthOneItem + widthDivider) / 2);
    }
    print(
        "wayAll:${wayAll} -- wayScreen:${wayScreen} -- countHalfScreen:${countHalfScreen} -- widthScreen:${widthScreen}");
    _controller.animateTo(
      wayFact,
      duration: const Duration(seconds: 5),
      curve: Curves.fastOutSlowIn,
    );
  }

  List<String> createListItems() {
    for (var i = 1; i < countItem + 1; i++) {
      final int itemIndex = random.nextInt(20) + 1;
      final String nameIamges = "assets/images/${itemIndex.toString()}.jpg";
      listItems.add(nameIamges);
    }
    return listItems;
  }

  void alertDialog(int selectItem) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Вы получили следующий приз!'),
        content: Image.asset(createListItems()[selectItem],
            width: _widthOneItem, height: _widthOneItem),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                startState();
                listItems = [];
                createListItems();
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int randomNumber = random.nextInt(51) + 30;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.rocket_launch_sharp),
        onPressed: () => _animateToIndex(context, randomNumber),
      ),
      body: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          itemCount: countItem,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                i == randomNumber ? alertDialog(randomNumber) : null;
              },
              child: SizedBox(
                width: _widthOneItem,
                child: Container(
                    color: i == randomNumber ? Colors.red : null,
                    child: Image.asset(createListItems()[i],
                        width: _widthOneItem, height: _widthOneItem)),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const VerticalDivider(
            width: widthDivider,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
