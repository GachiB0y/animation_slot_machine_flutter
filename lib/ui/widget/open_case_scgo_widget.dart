import 'dart:math';

import 'package:flutter/material.dart';

class OpenCaseCsGoWidget extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final double _height = 100.0;
  final Random random = Random();

  OpenCaseCsGoWidget({super.key});

  void _animateToIndex(int index) {
    _controller.animateTo(
      index * _height,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int randomNumber = random.nextInt(71) + 30;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.rocket_launch_sharp),
        onPressed: () => _animateToIndex(randomNumber),
      ),
      body: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          itemCount: 100,
          itemBuilder: (_, i) {
            return SizedBox(
              width: _height,
              //height: _height,
              child: Card(
                color: i == randomNumber ? Colors.blue : null,
                child: Center(child: Text('Item $i')),
              ),
            );
          },
        ),
      ),
    );
  }
}
