import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';

import '../../harness.dart';
import 'scoreboard_page_objects.dart';

void main() {
  group('ExitGameDialog', () {
    testGoldens(
      'Should look right',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ExitGameDialog());

        await then.multiScreenGoldensMatch(
          'exit_screen_dialog',
          devices: [Device.phone],
        );
      }),
    );

    testWidgets(
      'Should add ResetGameEvent without keeping names when yes button tapped',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ExitGameDialog());

        await when.userTaps(exitGameDialogPage.yesButton);
        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [ResetGameEvent(shouldKeepNames: false)],
        );

        then.findsNoWidget(exitGameDialogPage);
      }),
    );

    testWidgets(
      'Should dismiss dialog when not button tapped',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ExitGameDialog());

        await when.userTaps(exitGameDialogPage.noButton);
        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          isEmpty,
        );

        then.findsNoWidget(exitGameDialogPage);
      }),
    );
  });
}
