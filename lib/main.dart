import 'package:annimation_slot_machine/factories/di_container.dart';
import 'package:flutter/material.dart';

abstract class AppFactory {
  Widget makeApp();
}

final appFactory = makeFactoryApp();
void main() {
  final app = appFactory.makeApp();
  runApp(app);
}
