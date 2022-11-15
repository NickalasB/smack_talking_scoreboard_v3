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
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

import '../../harness.dart';
import '../../helpers/pump_material_widget.dart';
import 'scoreboard_page_objects.dart';

final scoreboardPage = ScoreBoardPageObject();

void main() {
  group('ScoreboardPage', () {
    testGoldens(
      'Should look correct',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await then.multiScreenGoldensMatch('scoreboard_page');
      }),
    );

    testWidgets('renders ScoreboardView', (tester) async {
      await tester.pumpMaterialWidget(const ScoreboardPage());
      expect(find.byType(ScoreboardView), findsOneWidget);
    });
  });

  group('ScoreboardView', () {
    testWidgets(
      'should add IncreaseScoreEvent when add button tapped',
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
      'should add DecreaseScoreEvent when swiping down on player score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.tester.timedDrag(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, 300),
          const Duration(milliseconds: 750),
        );

        await when.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [DecreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should add IncreaseScoreEvent when swiping up on player score',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ScoreboardView());

        await when.tester.timedDrag(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, -300),
          const Duration(milliseconds: 750),
        );

        await when.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [IncreaseScoreEvent(playerId: 1)],
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
      'Should show round winner UI when game has a winner and a round value',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          scoreboardState: const ScoreboardState(
            Game(
              players: [
                Player(playerId: 1),
                Player(playerId: 2),
              ],
              round: Round(
                roundCount: 2,
                roundWinner: Player(playerId: 2),
              ),
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
