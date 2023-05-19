import 'package:annimation_slot_machine/domain/blocs/open_case_scgo_view_cubit.dart';
import 'package:annimation_slot_machine/domain/blocs/slot_machine_view_cubit.dart';
import 'package:annimation_slot_machine/my_app.dart';
import 'package:annimation_slot_machine/ui/widget/open_case_scgo_widget.dart';
import 'package:annimation_slot_machine/ui/widget/slot_machine_widget.dart';
import 'package:flutter/material.dart';
import 'package:annimation_slot_machine/main.dart';
import 'package:annimation_slot_machine/ui/navigation/main_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppFactory makeFactoryApp() => const _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = const _DIContainer();
  const _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        mainNavigation: _diContainer._makeMyAppNavigation(),
      );
}

class _DIContainer {
  const _DIContainer();

  ScreenFactoryDefault _makeScreenFactory() => ScreenFactoryDefault(this);
  MainNavigation _makeMyAppNavigation() =>
      MainNavigationDefault(_makeScreenFactory());
}

class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;
  const ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeSlotMachineScreen() {
    return BlocProvider<SlotMachineCubit>(
      create: (_) => SlotMachineCubit(),
      child: const SlotMachineWidget(),
    );
  }

  @override
  Widget makeCaseCsGoScreen() {
    return BlocProvider<OpenCaseCubit>(
      create: (_) => OpenCaseCubit(),
      child: OpenCaseCsGoWidget(),
    );
  }
}
