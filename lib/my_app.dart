import 'package:annimation_slot_machine/ui/navigation/main_navigation_route_names.dart';
import 'package:flutter/material.dart';

abstract class MainNavigation {
  Map<String, Widget Function(BuildContext)> makeRoute();
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MainNavigation mainNavigation;
  const MyApp({super.key, required this.mainNavigation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainNavigationRouteNames.mainScreen,
      routes: mainNavigation.makeRoute(),
      onGenerateRoute: mainNavigation.onGenerateRoute,
      //home: const SlotMachineWidget(),
    );
  }
}
