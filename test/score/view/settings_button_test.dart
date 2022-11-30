import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_button.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
  group('Settings Button', () {
    testGoldens(
      'Settings bottom sheet should look right',
      appHarness((given, when, then) async {
        await given.pumpWidget(SettingsButton(given.harness.scoreBloc));

        await given.scoreBoardState(
          ScoreboardState(
            initialScoreboardState.game.copyWith(
              players: [testPlayer1, testPlayer2],
            ),
            insults: const ['you are lame Player1', 'Bad job Player2'],
          ),
        );

        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        await then.multiScreenGoldensMatch(
          'settings_dialog',
          devices: [Device.phone],
        );
      }),
    );
  });
}
