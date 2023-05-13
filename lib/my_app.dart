import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

const duration = Duration(milliseconds: 2000);

class StaggerExampleWidget extends StatefulWidget {
  const StaggerExampleWidget({super.key});

  @override
  State<StaggerExampleWidget> createState() => _StaggerExampleWidgetState();
}

class _StaggerExampleWidgetState extends State<StaggerExampleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlller;

  @override
  void initState() {
    super.initState();
    _controlller = AnimationController(vsync: this, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controlller.forward(from: 0.0);
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                color: Colors.black,
                child: ScaleTransitionExample(controller: _controlller),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Hero(
                placeholderBuilder: (context, heroSize, child) {
                  return Opacity(
                    opacity: 0.2,
                    child: child,
                  );
                },
                tag: 'some',
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScaleTransitionExample extends StatelessWidget {
  final AnimationController controller;
  const ScaleTransitionExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MyIconPainter(controller),
          size: const Size(300, 300),
        );
      },
    );
  }
}

class MyIconPainter extends CustomPainter {
  final AnimationController controller;

  late final Animation<double> dotGrow;
  late final Animation<double> lineGrow;
  late final Animation<double> lineMove;

  MyIconPainter(this.controller) {
    dotGrow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.250, curve: Curves.easeOut)),
    );
    lineGrow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.3, 0.666, curve: Curves.easeIn)),
    );
    lineMove = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.55, 1.0, curve: Curves.bounceOut)),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = dotGrow.value * 20;
    final oneOffsetLineOne = Offset(0.0, size.height);

    final linesPainter = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 40.0;

    final dotPainter = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    canvas.drawCircle(Offset(centerX, centerY), radius, dotPainter);

    if (dotGrow.value < 1.0) return;

    canvas.drawLine(
        Offset(
          centerX + (centerX * lineMove.value),
          centerY - (centerY * lineGrow.value),
        ),
        Offset(
          centerX - (centerX * lineMove.value),
          centerY + (centerY * lineGrow.value),
        ),
        linesPainter);

    canvas.drawLine(
        Offset(
          centerX - (centerX * lineMove.value),
          centerY - (centerY * lineGrow.value),
        ),
        Offset(
          centerX + (centerX * lineMove.value),
          centerY + (centerY * lineGrow.value),
        ),
        linesPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
