// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

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

        expect(then.harness.scoreBloc.addedEvents, [ResetGameEvent()]);
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

  group('GameWinnerDialogTest', () {
    testGoldens(
      'Should launch GameWinnerDialog when pressing change turn button when a user has won the game',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: initialScoreboardState.copyWith(
            game: initialScoreboardState.game.copyWith(gameWinner: testPlayer1),
          ),
        );

        await when.userTaps(scoreboardPage.changeTurnButton);
        await when.pump();

        then.findsWidget(scoreboardPage.gameWinnerDialog);

        await then.multiScreenGoldensMatch(
          'game_winner_dialog',
          devices: [Device.phone],
        );
      }),
    );
  });

  group('Settings Button', () {
    testWidgets(
      'Should launch Settings Bottom sheet when clicking on settings button',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());
        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidget(scoreboardPage.settingsBottomSheet);
      }),
    );

    testWidgets(
      'Should add DeleteInsultEvent when user swipes insult from Settings BottomSheet',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: initialScoreboardState.copyWith(
            insults: [
              'insult1',
              'insult2',
            ],
          ),
        );
        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidget(find.text('insult1'));

        await when.userSwipesHorizontally(find.text('insult1'));
        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [DeleteInsultEvent('insult1')],
        );

        then.findsNoWidget(find.text('insult1'));
      }),
    );

    testGoldens(
      'Should display correct background color and icon when user swipes insult LEFT from Settings BottomSheet',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: initialScoreboardState.copyWith(
            insults: [
              'insult1',
            ],
          ),
        );
        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidget(find.text('insult1'));

        await when.userSwipesHorizontally(find.text('insult1'), dx: -500);

        await then.multiScreenGoldensMatch(
          'swipe_to_delete_insult_left',
          devices: [Device.phone],
          shouldSkipPumpAndSettle: true,
        );
      }),
    );

    testGoldens(
      'Should display correct background color and icon when user swipes insult RIGHT from Settings BottomSheet',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: initialScoreboardState.copyWith(
            insults: [
              'insult1',
            ],
          ),
        );
        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidget(find.text('insult1'));

        await when.userSwipesHorizontally(find.text('insult1'), dx: 500);

        await then.multiScreenGoldensMatch(
          'swipe_to_delete_insult_right',
          devices: [Device.phone],
          shouldSkipPumpAndSettle: true,
        );
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
          [NextTurnEvent()],
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
            (widget) => widget is ChangeTurnButton && widget.onTap == null,
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
  });
}

ScoreboardState _stateWithAGameWinner = initialScoreboardState.copyWith(
  game: initialScoreboardState.game.copyWith(gameWinner: testPlayer1),
);
