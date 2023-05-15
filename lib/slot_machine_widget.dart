import 'dart:async';
import 'package:annimation_slot_machine/domain/blocs/slot_machine_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const duration = Duration(milliseconds: 1000);
const int _secondsStart = 3;

class SlotMAchineWidget extends StatefulWidget {
  const SlotMAchineWidget({super.key});

  static Widget create() {
    return BlocProvider<SlotMachineCubit>(
      create: (_) => SlotMachineCubit(),
      child: const SlotMAchineWidget(),
    );
  }

  @override
  State<SlotMAchineWidget> createState() => _SlotMAchineWidgetState();
}

class _SlotMAchineWidgetState extends State<SlotMAchineWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlller;
  Timer? _timer;
  int _start = _secondsStart;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    final cubit = context.read<SlotMachineCubit>();
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        cubit.changeIndex();
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
    final cubit = context.read<SlotMachineCubit>();
    _controlller = AnimationController(vsync: this, duration: duration);
    _controlller.addListener(() {
      if (_controlller.isCompleted) {
        cubit.winOrLoose(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SlotMachineCubit>();
    final index = cubit.state.index;
    final isAnimation = cubit.state.isNotRunAnimation;
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: isAnimation,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controlller.isCompleted) {
                    _controlller.stop(canceled: true);
                    _controlller.reset();
                    _start = _secondsStart;
                  }
                  _controlller.repeat();
                  cubit.changeIsAnimationRun();
                  startTimer();
                  cubit.changeIndex();
                });
              },
              backgroundColor: Color.fromARGB(255, 186, 23, 12),
              child: const Text("START"),
            ),
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
            const SizedBox(
              height: 10,
            ),
            const BalanceWidget(),
            const SizedBox(
              height: 10,
            ),
            const BettingWidget(),
          ],
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SlotMachineCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Баланс:${cubit.state.currentBalance}"),
        TextButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Окно пополнения баланса!'),
              content: SizedBox(
                width: 100,
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: 'Ваша ставка', border: OutlineInputBorder()),
                  onChanged: cubit.topUpBalance,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
          child: const Text('Пополнить баланс'),
        ),
      ],
    );
  }
}

class BettingWidget extends StatelessWidget {
  const BettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SlotMachineCubit>();
    final isAnimation = cubit.state.isNotRunAnimation;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Текущая ставка:${cubit.state.bet}"),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 160,
              child: TextField(
                enabled: isAnimation,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Ваша ставка',
                    border: OutlineInputBorder()),
                onChanged: cubit.changeBet,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text("Возможный выигрыш:${cubit.state.bet * cubit.state.rate}")
      ],
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
    final radiusGrow = dotGrow.value * 20;
    final radiusDestroy = dotDestroy.value * 20;
    List colors = const [
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
