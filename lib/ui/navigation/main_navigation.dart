import 'package:annimation_slot_machine/my_app.dart';
import 'package:annimation_slot_machine/ui/navigation/main_navigation_route_names.dart';
import 'package:flutter/material.dart';

abstract class ScreenFactory {
  Widget makeSlotMachineScreen();
  Widget makeCaseCsGoScreen();
}

class MainNavigationDefault implements MainNavigation {
  final ScreenFactory screenFactory;

  MainNavigationDefault(this.screenFactory);

  @override
  Map<String, Widget Function(BuildContext)> makeRoute() =>
      <String, Widget Function(BuildContext)>{
        MainNavigationRouteNames.mainScreen: (_) =>
            screenFactory.makeSlotMachineScreen(),
        MainNavigationRouteNames.openCaseScreen: (_) =>
            screenFactory.makeCaseCsGoScreen(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        const widget = Text('Navigation error!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }
}
