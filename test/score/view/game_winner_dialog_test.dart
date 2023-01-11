import 'package:confetti/confetti.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/game_winner_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
  group('GameWinnerDialogTest', () {
    testGoldens(
      'Should look right',
      appHarness((given, when, then) async {
        await given.pumpWidget(GameWinnerDialog(
          testPlayer1,
          shouldPlayAtLaunch: false,
        ));

        await then.multiScreenGoldensMatch(
          'game_winner_dialog',
        );
      }),
    );

    testWidgets(
      'Should add ResetGameEvent, keep names and pop when yes button pressed',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          GameWinnerDialog(testPlayer1),
          scoreboardState: _testGameWinnerState(testPlayer1),
        );

        await when.userTaps(gameWinnerDialogPage.yesButton);
        then.addedScoreBlocEvents(
          containsAll(
            [ResetGameEvent(shouldKeepNames: true)],
          ),
        );
        expect(then.harness.navigationObserver.didPopRoute, isTrue);
      }),
    );

    testWidgets(
      'Should add ResetGameEvent, NOT keep names, and pop when yes button pressed',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          GameWinnerDialog(testPlayer1),
          scoreboardState: _testGameWinnerState(testPlayer1),
        );

        await when.userTaps(gameWinnerDialogPage.noButton);
        then.addedScoreBlocEvents(
          containsAll(
            [ResetGameEvent(shouldKeepNames: false)],
          ),
        );
        expect(then.harness.navigationObserver.didPushRoute, isTrue);
      }),
    );

    testWidgets(
      'Should play confetti blast when dialog launched',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          GameWinnerDialog(testPlayer1),
          scoreboardState: _testGameWinnerState(testPlayer1),
        );

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ConfettiWidget &&
                widget.confettiController.state ==
                    ConfettiControllerState.playing,
          ),
        );
      }),
    );

    testWidgets(
      'Should be unable to dismiss dialog with system back button',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          GameWinnerDialog(testPlayer1),
          scoreboardState: _testGameWinnerState(testPlayer1),
        );
        final doNotPopResult = when.deviceBackButtonPressedResult();

        //A result of true actually translates to RoutePopDisposition.doNotPop inside of maybePop in Navigator.dart
        expect(await doNotPopResult, isTrue);
      }),
    );
  });
}

ScoreboardState _testGameWinnerState(Player winningPlayer) {
  return initialScoreboardState.copyWith(
    game: initialScoreboardState.game.copyWith(gameWinner: winningPlayer),
  );
}
