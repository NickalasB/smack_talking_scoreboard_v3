import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/view/app.dart';
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
      'Should pop and push to home and add ResetGameEvent without keeping names when YES button tapped',
      appHarness((given, when, then) async {
        await given.pumpWidget(const ExitGameDialog());

        await when.userTaps(exitGameDialogPage.yesButton);
        await when.pumpAndSettle();
        await when.pumpAndSettle();

        expect(
          then.harness.scoreBloc.addedEvents,
          [ResetGameEvent(shouldKeepNames: false)],
        );

        expect(
          then.harness.navigationObserver.newRoute,
          const TypeMatcher<Route<dynamic>?>()
              .having((p0) => p0?.settings.name, 'routName', homeRouteName),
        );

        expect(then.harness.navigationObserver.didPopRoute, isTrue);
      }),
    );

    testWidgets(
      'Should dismiss dialog when NO button tapped',
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
