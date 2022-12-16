// ignore_for_file:prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';

import '../../flutter_test_config.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AppState', () {
    test('Should have value-type equality', () {
      final appState1 = AppState(insults: const ['A']);

      expect(appState1, equals(appState1.copyWith()));
      expect(appState1, isNot(appState1.copyWith(insults: ['B'])));
    });
  });

  group('LoadDefaultInsultsEvent', () {
    test('should add default insults', () async {
      final bloc = AppBloc()
        ..add(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default1', 'default2'],
          ),
        );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['default1', 'default2'],
          ),
        ),
      );
    });

    test('should include user saved insults', () async {
      final bloc = AppBloc()
        ..add(
          SaveInsultEvent('userSavedInsult'),
        );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
        ),
      );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['userSavedInsult', 'default1', 'default2'],
          ),
        ),
      );
    });

    test(
        'should only one include one instance of default insults plus user saved insults when added more than once',
        () async {
      final bloc = AppBloc()
        ..add(
          SaveInsultEvent('userSavedInsult'),
        );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
        ),
      );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
        ),
      );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['userSavedInsult', 'default1', 'default2'],
          ),
        ),
      );
    });

    test(
        'should allow deleting of default insults only load modified default insults',
        () async {
      final bloc = AppBloc()
        ..add(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default1', 'default2'],
          ),
        );
      await tick();

      bloc.add(
        DeleteInsultEvent('default1'),
      );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
        ),
      );

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['default2'],
          ),
        ),
      );
    });
  });

  group('SaveInsultEvent', () {
    test(
        'should emit state with new insult when SaveInsultEvent added with valid text',
        () async {
      final bloc = AppBloc();
      await tick();

      bloc.add(SaveInsultEvent('be better'));
      await tick();

      final updatedState = const AppState().copyWith(
        insults: const ['be better'],
      );

      await tick();

      expectStateAndHydratedState(bloc, equals(updatedState));
    });

    test(
        'should NOT emit state with new insult when SaveInsultEvent added with empty or null text',
        () async {
      final bloc = AppBloc();
      await tick();

      bloc.add(SaveInsultEvent(''));
      await tick();
      expectStateAndHydratedState(
        bloc,
        equals(const AppState()),
      );

      bloc.add(SaveInsultEvent(null));
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(const AppState()),
      );
    });
  });

  group('DeleteInsultEvent', () {
    test('Should remove insult when DeleteInsultEvent added', () async {
      final stateWithInsults = const AppState().copyWith(
        insults: const [
          'insult1',
          'insult2',
        ],
      );

      final bloc = AppBloc()..emit(stateWithInsults);
      await tick();

      bloc.add(DeleteInsultEvent('insult1'));
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          stateWithInsults.copyWith(
            insults: const ['insult2'],
          ),
        ),
      );
    });
  });
}

void expectStateAndHydratedState(AppBloc bloc, dynamic matcher) {
  expect(bloc.state, matcher);
  expect(bloc.fromJson(testStorage.read('AppBloc')!), matcher);
}
