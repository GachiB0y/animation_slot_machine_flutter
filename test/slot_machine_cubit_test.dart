import 'package:annimation_slot_machine/domain/blocs/slot_machine_view_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('SlotMachineCubit test', () {
    late SlotMachineCubit slotMachineCubit;
    late SlotMachineViewState slotMachineViewState;
    const int balance = 1000;
    const int bet = 25;

    setUp(() {
      slotMachineCubit = SlotMachineCubit();
      slotMachineViewState = SlotMachineViewState(
          currentBalance: 0,
          bet: 0,
          jackpot: false,
          index: [1, 1, 1],
          isNotRunAnimation: true);
    });

    test('initial state balance is 0', () {
      expect(slotMachineCubit.state.currentBalance, 0);
    });

    test('Test Top Up Balance is 1000', () {
      slotMachineCubit.topUpBalance(balance.toString());
      expect(slotMachineCubit.state.currentBalance, 1000);
    });

    test('changeBet is 25', () {
      slotMachineCubit.topUpBalance(balance.toString());
      slotMachineCubit.changeBet(bet.toString());
      expect(slotMachineCubit.state.bet, 25);
    });

    test('Test incrementBalanceWithWin when bet is 25', () {
      slotMachineCubit.topUpBalance(balance.toString());
      slotMachineCubit.changeBet(bet.toString());
      slotMachineCubit.incrementBalanceWithWin();
      expect(slotMachineCubit.state.currentBalance, 1250);
    });

    test('Test decrementBalanceWithLoose when bet is 25', () {
      slotMachineCubit.topUpBalance(balance.toString());
      slotMachineCubit.changeBet(bet.toString());
      slotMachineCubit.decrementBalanceWithLoose();
      expect(slotMachineCubit.state.currentBalance, 975);
    });

    // blocTest<SlotMachineCubit, SlotMachineViewState>(
    //   'Test Top Up Balance',
    //   build: () => slotMachineCubit,
    //   act: (cubit) {
    //     cubit.topUpBalance(balance.toString());
    //   },
    //   expect: () {
    //     SlotMachineViewState(
    //       currentBalance: 1000,
    //       bet: 0,
    //       jackpot: false,
    //       isNotRunAnimation: true,
    //       index: [1, 1, 1],
    //     );
    //     // slotMachineViewState.copyWith(currentBalance: balance);
    //   },
    // );

    tearDown(() => slotMachineCubit.close());
  });
}
