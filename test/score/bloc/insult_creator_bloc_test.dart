// ignore_for_file:prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('InsultCreatorBloc', () {
    test('Initial state should be empty constructed insult', () {
      expect(
        InsultCreatorBloc().state,
        InsultCreatorState(''),
      );
    });

    group('CreateInsultEvent', () {
      test(r'Should replace "$HI/LOW$" with hiLowKey', () async {
        final bloc = InsultCreatorBloc()
          ..add(CreateInsultEvent(r'$HI/LOW$', index: 0));
        await tick();

        expect(
          bloc.state,
          InsultCreatorState(inValidKey),
        );
      });

      test('Should emit insult when not invalid', () async {
        final bloc = InsultCreatorBloc()
          ..add(CreateInsultEvent('any insult', index: 0));
        await tick();

        expect(
          bloc.state,
          InsultCreatorState('any insult'),
        );
      });

      test('Should add spaces between each added insult', () async {
        final bloc = InsultCreatorBloc();
        await tick();

        bloc.add(CreateInsultEvent('Should have space between me', index: 0));
        await tick();

        bloc.add(CreateInsultEvent('and me', index: 1));
        await tick();

        expect(
          bloc.state,
          InsultCreatorState('Should have space between me and me'),
        );
      });
    });
  });

  group('CreateInsultEvent', () {
    test('Should have value-type equality', () {
      final createInsultEvent1 = CreateInsultEvent('anything1', index: 1);

      expect(
        createInsultEvent1,
        equals(CreateInsultEvent('anything1', index: 1)),
      );

      expect(
        createInsultEvent1,
        isNot(CreateInsultEvent('anything2', index: 1)),
      );

      expect(
        createInsultEvent1,
        isNot(CreateInsultEvent('anything1', index: 2)),
      );
    });
  });
}
