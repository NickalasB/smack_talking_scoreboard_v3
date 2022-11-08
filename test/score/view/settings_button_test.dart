import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_button.dart';

import '../../harness.dart';
import 'scoreboard_page_objects.dart';

final scoreboardPage = ScoreBoardPageObject();

void main() {
  group('Settings Button', () {
    testGoldens(
      'Settings bottom sheet should look right',
      appHarness((given, when, then) async {
        await given.pumpWidget(const SettingsButton());

        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        await then.multiScreenGoldensMatch(
          'settings_dialog',
          devices: [Device.phone],
        );
      }),
    );

    testWidgets(
      'Should add SaveInsultEvent when hitting dialog done button',
      appHarness((given, when, then) async {
        await given.pumpWidget(const SettingsButton());

        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidget(scoreboardPage.settingsBottomSheet);

        await when.userTypes('anything', scoreboardPage.insultTextField);
        await when.pumpAndSettle();

        await when.userTaps(scoreboardPage.doneButton);
        await when.pumpAndSettle();

        await when.idle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [SaveInsultEvent('anything')],
        );
      }),
    );
  });
}
