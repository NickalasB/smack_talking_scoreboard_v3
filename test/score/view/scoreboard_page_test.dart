// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
  group('ScoreboardPage', () {
    testGoldens(
      'Should look correct',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardPage());

        await then.multiScreenGoldensMatch('scoreboard_page');
      }),
    );

    testWidgets(
      'renders ScoreboardView',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardPage());
        expect(find.byType(ScoreboardView), findsOneWidget);
      }),
    );
  });

  group('ScoreboardView', () {
    testWidgets(
      'Should allow willPopScope when ExitGameDialog returns true result',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithDependencies(
          const ScoreboardView(),
        );

        final doNotPopResult = when.deviceBackButtonPressedResult();

        when.exitGameDialogReturns(shouldExitGame: true);

        //A result of false actually translates to RoutePopDisposition.bubble(do pop) inside of maybePop in Navigator.dart
        expect(await doNotPopResult, isFalse);
      }),
    );

    testWidgets(
      'Should NOT allow willPopScope when ExitGameDialog returns false result',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithDependencies(
          const ScoreboardView(),
        );

        final doNotPopResult = when.deviceBackButtonPressedResult();

        when.exitGameDialogReturns(shouldExitGame: false);

        //A result of true actually translates to RoutePopDisposition.doNotPop inside of maybePop in Navigator.dart
        expect(await doNotPopResult, isTrue);
      }),
    );

    testWidgets(
      'should add IncreaseScoreEvent when tapping on player score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());
        await when.userTaps(scoreboardPage.playerScore(forPlayerId: 1));
        expect(
          then.harness.scoreBloc.addedEvents,
          [IncreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should NOT add IncreaseScoreEvent tapping on playerScore if gameWinner is not null',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: _stateWithAGameWinner,
        );
        await when.userTaps(scoreboardPage.playerScore(forPlayerId: 1));
        expect(
          then.harness.scoreBloc.addedEvents,
          isEmpty,
        );
      }),
    );

    testWidgets(
      'should add DecreaseScoreEvent when swiping down on player score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.userDragsVertically(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, 300),
        );

        await when.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [DecreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should NOT add DecreaseScoreEvent when swiping down on player score if gameWinner is not null',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: _stateWithAGameWinner,
        );

        await when.userDragsVertically(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, 300),
        );

        await when.pump();
        expect(
          then.harness.scoreBloc.addedEvents,
          isEmpty,
        );
      }),
    );

    testWidgets(
      'should add IncreaseScoreEvent when swiping up on player score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.userDragsVertically(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, -300),
        );

        await when.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [IncreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should NOT add IncreaseScoreEvent when swiping up on player score if gameWinner is not null',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: _stateWithAGameWinner,
        );

        await when.userDragsVertically(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, -300),
        );

        await when.pump();
        expect(
          then.harness.scoreBloc.addedEvents,
          isEmpty,
        );
      }),
    );
  });

  group('ResetGame Dialog', () {
    testGoldens(
      'should launch reset game dialog when long-pressing a score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.tester.longPress(
          scoreboardPage.playerScore(forPlayerId: 1),
        );

        await when.pumpAndSettle();
        then.findsWidget(scoreboardPage.resetScoreDialog);
        await then.multiScreenGoldensMatch('reset_score_dialog');
      }),
    );

    testWidgets(
      'should add ResetScoreEvent when user hits Yes on reset game dialog',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.tester.longPress(
          scoreboardPage.playerScore(forPlayerId: 1),
        );

        await when.pumpAndSettle();
        await when.userTaps(find.text('Yes'));
        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [ResetGameEvent(shouldKeepNames: true)],
        );
        then.findsNoWidget(scoreboardPage.resetScoreDialog);
      }),
    );

    testWidgets(
      'should dismiss reset game dialog when user hit No button',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.tester.longPress(
          scoreboardPage.playerScore(forPlayerId: 1),
        );

        await when.pumpAndSettle();
        await when.userTaps(find.text('No'));
        await when.pumpAndSettle();

        expect(then.harness.scoreBloc.addedEvents, isEmpty);
        then.findsNoWidget(scoreboardPage.resetScoreDialog);
      }),
    );
  });

  group('ChangeTurnButton', () {
    testWidgets(
      'Should add NextTurnEvent when ChangeTurn button pressed',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.userTaps(scoreboardPage.changeTurnButton);

        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [NextTurnEvent(const <String>[])],
        );
      }),
    );

    testWidgets(
      'Should disable ChangeTurn button when gameWinner is not null',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: _stateWithAGameWinner,
        );

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is CircularButton &&
                widget.key == const Key('change_turn_button') &&
                widget.onTap == null,
          ),
        );
      }),
    );

    testWidgets(
      'Should show round winner UI when game has a winner and a round value',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: initialScoreboardState.copyWith(
            game: Game(
              players: [
                testPlayer1,
                testPlayer2,
              ],
              round: Round(
                roundCount: 2,
                roundWinner: testPlayer2,
              ),
              gamePointParams: initialScoreboardState.game.gamePointParams,
            ),
          ),
        );

        then
          ..findsWidget(find.text('Round: 2'))
          ..findsWidget(find.text('Round Winner: Player 2'));
      }),
    );

    testWidgets(
      'Should call launchGameWinnerDialog when game has winner',
      appHarness((given, when, then) async {
        final gameWithoutWinner = Game(
          players: [testPlayer1, testPlayer2],
          gamePointParams: initialScoreboardState.game.gamePointParams,
        );
        await given.pumpWidgetWithDependencies(
          const ScoreboardView(),
        );

        await given.scoreBoardState(
          initialScoreboardState.copyWith(game: gameWithoutWinner),
        );

        expect(then.harness.launchGameWinnerDialogCompleters, isEmpty);

        when.harness.scoreBloc.emit(
          initialScoreboardState.copyWith(
            game: gameWithoutWinner.copyWith(gameWinner: testPlayer2),
          ),
        );

        await when.userTaps(scoreboardPage.changeTurnButton);
        await when.pumpAndSettle();
        when.launchGameWinnerDialogCompletes(withPlayer: testPlayer2);

        expect(then.harness.launchGameWinnerDialogCompleters, isNotEmpty);
      }),
    );
  });
}

ScoreboardState _stateWithAGameWinner = initialScoreboardState.copyWith(
  game: initialScoreboardState.game.copyWith(gameWinner: testPlayer1),
);
