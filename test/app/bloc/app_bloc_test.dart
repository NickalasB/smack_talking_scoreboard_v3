// ignore_for_file:prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

import '../../flutter_test_config.dart';
import '../../helpers/fake_tts.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AppState', () {
    test('Should have value-type equality', () {
      final appState1 = AppState(
        insults: const ['A'],
        tieInsults: const ['1'],
        availableVoices: const [Voice(name: 'anyName', locale: 'anyLocale')],
        selectedVoice: Voice(name: 'anyName', locale: 'anyLocale'),
        originalDefaultInsults: const ['A'],
        deletedDefaultInsults: const ['A'],
        didCompleteInitialLoad: true,
      );

      expect(appState1, equals(appState1.copyWith()));
      expect(appState1, isNot(appState1.copyWith(insults: ['B'])));
      expect(
        appState1,
        isNot(
          appState1.copyWith(
            availableVoices: const [
              Voice(name: 'anyName2', locale: 'anyLocale2'),
            ],
          ),
        ),
      );
      expect(
        appState1,
        isNot(
          appState1.copyWith(
            selectedVoice: const Voice(name: 'anyName2', locale: 'anyLocale2'),
          ),
        ),
      );
      expect(appState1, isNot(appState1.copyWith(tieInsults: ['2'])));
      expect(
        appState1,
        isNot(appState1.copyWith(originalDefaultInsults: ['B'])),
      );
      expect(
        appState1,
        isNot(appState1.copyWith(deletedDefaultInsults: ['B'])),
      );
      expect(
        appState1,
        isNot(appState1.copyWith(didCompleteInitialLoad: false)),
      );
    });

    test('toString', () {
      final state = AppState().copyWith(
        insults: const ['insult1'],
        tieInsults: const ['tieDefault1'],
        availableVoices: const [Voice(name: 'anyName', locale: 'anyLocale')],
        selectedVoice: const Voice(name: 'anyName', locale: 'anyLocale'),
        originalDefaultInsults: const ['default1'],
        deletedDefaultInsults: const ['default1'],
        didCompleteInitialLoad: true,
      );
      expect(
        state.toString(),
        'AppState(\n'
        'insults:[insult1]\n'
        'tieInsults:[tieDefault1]\n'
        'availableVoices:[Voice(anyName, anyLocale)]\n'
        'selectedVoice:Voice(anyName, anyLocale)\n'
        'originalDefaultInsults:[default1]\n'
        'deletedDefaultInsults:[default1]\n'
        'didCompleteInitialLoad:true\n)',
      );
    });
  });

  group('LoadDefaultInsultsEvent', () {
    test('should add default insults', () async {
      final bloc = await _appBlocInitializedWith(
        defaultInsults: const ['default1', 'default2'],
        defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
      );

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['default1', 'default2'],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            originalDefaultInsults: const ['default1', 'default2'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });

    test('should include user saved insults', () async {
      final bloc = await _appBlocInitializedWith()
        ..add(
          SaveInsultEvent('userSavedInsult'),
        );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['userSavedInsult', 'default1', 'default2'],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            originalDefaultInsults: const ['default1', 'default2'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });

    test(
        'should emit state with empty default insults when a user has deleted them all',
        () async {
      final bloc = _appBloc
        ..add(
          SaveInsultEvent('userSavedInsult'),
        );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );
      await tick();

      bloc.add(DeleteInsultEvent('default1'));
      await tick();
      bloc.add(DeleteInsultEvent('default2'));
      await tick();
      bloc.add(DeleteInsultEvent('userSavedInsult'));
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const [],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            originalDefaultInsults: const ['default1', 'default2'],
            deletedDefaultInsults: const ['default1', 'default2'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });

    test(
        'should only one include one instance of default insults plus user saved insults when added more than once',
        () async {
      final bloc = _appBloc
        ..add(
          SaveInsultEvent('userSavedInsult'),
        );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['userSavedInsult', 'default1', 'default2'],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            availableVoices: [],
            originalDefaultInsults: const ['default1', 'default2'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });

    test(
        'should allow deleting of default insults only load modified default insults',
        () async {
      final bloc = await _appBlocInitializedWith(
        defaultInsults: const ['default1', 'default2'],
        defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
      );

      bloc.add(
        DeleteInsultEvent('default1'),
      );
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['default2'],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            availableVoices: [],
            originalDefaultInsults: const ['default1', 'default2'],
            deletedDefaultInsults: const ['default1'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });

    test(
        'should update default insults when new defaultInsults added, while not re-adding deleted default insults',
        () async {
      final bloc = await _appBlocInitializedWith(
        defaultInsults: const ['default1', 'default2'],
        defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
      );

      bloc.add(DeleteInsultEvent('default1'));
      await tick();

      bloc.add(SaveInsultEvent('userInsult1'));
      await tick();

      bloc.add(SaveInsultEvent('userInsult2'));
      await tick();

      bloc.add(DeleteInsultEvent('userInsult1'));
      await tick();

      bloc.add(
        LoadDefaultInsultsEvent(
          defaultInsults: const ['default1', 'default2', 'newDefaultInsult'],
          defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
        ),
      );

      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            insults: const ['userInsult2', 'default2', 'newDefaultInsult'],
            tieInsults: const ['tieDefault1', 'tieDefault2'],
            availableVoices: [],
            originalDefaultInsults: const [
              'default1',
              'default2',
              'newDefaultInsult',
            ],
            deletedDefaultInsults: const ['default1'],
            didCompleteInitialLoad: true,
          ),
        ),
      );
    });
  });

  group('LoadAvailableVoicesEvent', () {
    test('should call tts.available voices on bloc initialization', () async {
      final fakeTts = FakeTts();
      final bloc = await _appBlocInitializedWith(
        tts: fakeTts,
        availableVoices: [Voice(name: 'anyName', locale: 'anyLocale')],
      );

      expect(fakeTts.getVoicesCompleters, hasLength(1));

      expectStateAndHydratedState(
        bloc,
        equals(
          const AppState().copyWith(
            didCompleteInitialLoad: true,
            availableVoices: [Voice(name: 'anyName', locale: 'anyLocale')],
          ),
        ),
      );
    });
  });

  group('SaveInsultEvent', () {
    test(
        'should emit state with new insult when SaveInsultEvent added with valid text',
        () async {
      final bloc = _appBloc;
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
      final bloc = _appBloc;
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

      final bloc = _appBloc..emit(stateWithInsults);
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

    test(
        'Should add deleted insult to state.deletedDefaultInsults when deleted insult is from defaults',
        () async {
      final stateWithInsults = const AppState().copyWith(
        originalDefaultInsults: const ['default1', 'default2'],
        insults: const ['default1', 'default2'],
      );

      final bloc = _appBloc..emit(stateWithInsults);
      await tick();

      bloc.add(DeleteInsultEvent('default1'));
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          stateWithInsults.copyWith(
            insults: const ['default2'],
            originalDefaultInsults: const ['default1', 'default2'],
            deletedDefaultInsults: const ['default1'],
          ),
        ),
      );
    });

    test(
        'Should NOT add deleted insult to state.deletedDefaultInsults when deleted insult is NOT from defaults',
        () async {
      final stateWithInsults = const AppState().copyWith(
        originalDefaultInsults: const ['default1', 'default2'],
        insults: const ['default1', 'default2', 'userInsult'],
      );

      final bloc = _appBloc..emit(stateWithInsults);
      await tick();

      bloc.add(DeleteInsultEvent('userInsult'));
      await tick();

      expectStateAndHydratedState(
        bloc,
        equals(
          stateWithInsults.copyWith(
            insults: const ['default1', 'default2'],
            originalDefaultInsults: const ['default1', 'default2'],
            deletedDefaultInsults: const [],
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

AppBloc get _appBloc => AppBloc(FakeTts());

AppBloc appBloc(Tts? tts) => AppBloc(tts ?? FakeTts());

Future<AppBloc> _appBlocInitializedWith({
  FakeTts? tts,
  List<Voice> availableVoices = const [],
  List<String> defaultInsults = const [],
  List<String> defaultTieInsults = const [],
}) async {
  final fakeTts = tts ?? FakeTts();

  final bloc = appBloc(fakeTts)
    ..add(
      LoadDefaultInsultsEvent(
        defaultInsults: defaultInsults,
        defaultTieInsults: defaultTieInsults,
      ),
    );

  await tick();

  fakeTts.getVoicesCompleters.last.complete(availableVoices);

  await tick();

  return bloc;
}
