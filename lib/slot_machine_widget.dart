import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

const duration = Duration(milliseconds: 1000);
const int _secondsStart = 3;

class SlotMAchineWidget extends StatefulWidget {
  const SlotMAchineWidget({super.key});

  @override
  State<SlotMAchineWidget> createState() => _SlotMAchineWidgetState();
}

class _SlotMAchineWidgetState extends State<SlotMAchineWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlller;
  bool jackpot = false;
  Timer? _timer;
  int _start = _secondsStart;
  final Random random = new Random();
  final List<int> index = [
    1,
    1,
    1,
  ];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        changeIndex();
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _controlller.forward(from: 0.0);
            _controlller.animateTo(0.65);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controlller = AnimationController(vsync: this, duration: duration);
    _controlller.addListener(() {
      if (_controlller.isCompleted) {
        print("${index[0]}-- ${index[1]}-- ${index[2]}");
        if (index[0] == index[1] && index[1] == index[2]) {
          setState(() {
            jackpot = true;
          });
          print('JACK: $jackpot');
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Внимание!'),
              content: const Text('Вы выиграли!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  void changeIndex() {
    index[0] = random.nextInt(5);
    index[1] = random.nextInt(5);
    index[2] = random.nextInt(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                jackpot = false;
                if (_controlller.isCompleted) {
                  _controlller.stop(canceled: true);
                  _controlller.reset();
                  _start = _secondsStart;
                }
                _controlller.repeat();
                startTimer();
                changeIndex();
              });
            },
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    color: Colors.black,
                    child: ScaleTransitionExample(
                      controller: _controlller,
                      index: index,
                    ),
                  ),
                ],
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
  final List<int> index;
  const ScaleTransitionExample({
    Key? key,
    required this.controller,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MyIconPainter(controller, index),
          size: const Size(300, 300),
        );
      },
    );
  }
}

class MyIconPainter extends CustomPainter {
  final List<int> index;
  final AnimationController controller;
  late final Animation<double> dotGrow;
  late final Animation<double> dotDestroy;
  late final Animation<double> dotMove;
  late final Animation<double> dotMove2;
  late final Animation<double> dotMove3;

  MyIconPainter(
    this.controller,
    this.index,
  ) {
    dotGrow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.150, curve: Curves.easeOut)),
    );
    dotDestroy = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.850, 1.0, curve: Curves.easeOut)),
    );
    dotMove = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut)),
    );
    dotMove2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.50, 1.0, curve: Curves.easeOut)),
    );
    dotMove3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: controller,
          curve: const Interval(0.750, 1.0, curve: Curves.easeOut)),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radiusGrow = dotGrow.value * 20;
    final radiusDestroy = dotDestroy.value * 20;
    List colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.blue,
      Color.fromARGB(255, 236, 72, 127)
    ];

    final dotPainter = Paint()
      ..color = colors[index[0]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter1 = Paint()
      ..color = colors[index[1]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter2 = Paint()
      ..color = colors[index[2]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter3 = Paint()
      ..color = colors[index[2]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter4 = Paint()
      ..color = colors[index[1]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter5 = Paint()
      ..color = colors[index[0]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter6 = Paint()
      ..color = colors[index[1]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter7 = Paint()
      ..color = colors[index[0]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;
    final dotPainter8 = Paint()
      ..color = colors[index[2]]
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    canvas.drawCircle(Offset(centerX, 0 + (size.height * dotMove.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter);

    canvas.drawCircle(Offset(0, 0 + (size.height * dotMove.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter1);

    canvas.drawCircle(Offset(size.width, 0 + (size.height * dotMove.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter2);

    if (dotMove.value < 0.5) return;
    canvas.drawCircle(Offset(centerX, 0 + (size.height * dotMove2.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter3);
    canvas.drawCircle(Offset(0, 0 + (size.height * dotMove2.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter4);

    canvas.drawCircle(Offset(size.width, 0 + (size.height * dotMove2.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter5);

    if (dotMove.value < 0.75) return;
    canvas.drawCircle(Offset(centerX, 0 + (size.height * dotMove3.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter6);
    canvas.drawCircle(Offset(0, 0 + (size.height * dotMove3.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter7);

    canvas.drawCircle(Offset(size.width, 0 + (size.height * dotMove3.value)),
        dotGrow.value < 1.0 ? radiusGrow : radiusDestroy, dotPainter8);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
