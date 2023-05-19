import 'package:annimation_slot_machine/domain/blocs/open_case_scgo_view_cubit.dart';
import 'package:annimation_slot_machine/ui/navigation/main_navigation_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenCaseCsGoWidget extends StatelessWidget {
  OpenCaseCsGoWidget({super.key});

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<OpenCaseCubit>();
    final int randomNumber = cubit.state.random.nextInt(51) + 30;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'Next',
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MainNavigationRouteNames.mainScreen);
              },
              backgroundColor: Colors.blue,
              child: const Text("Back"),
            ),
            FloatingActionButton(
              child: const Icon(Icons.rocket_launch_sharp),
              onPressed: () =>
                  cubit.animateToIndex(context, randomNumber, _controller),
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          itemCount: cubit.state.countItem,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                i == randomNumber
                    ? cubit.alertDialog(context, randomNumber, _controller)
                    : null;
              },
              child: SizedBox(
                width: cubit.state.widthOneItem,
                child: Container(
                    color: i == randomNumber ? Colors.red : null,
                    child: Image.asset(cubit.state.items[i],
                        width: cubit.state.widthOneItem,
                        height: cubit.state.widthOneItem)),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              VerticalDivider(
            width: cubit.state.widthDivider,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
