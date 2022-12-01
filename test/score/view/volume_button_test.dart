import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/volume_button.dart';

import '../../harness.dart';
import 'scoreboard_page_objects.dart';

void main() {
  group('Settings Button', () {
    testWidgets(
      'Should toggle volume on and off',
      appHarness((given, when, then) async {
        await given.pumpWidget(const VolumeButton());

        await when.userTaps(scoreboardPage.volume);
        expect(then.harness.scoreBloc.addedEvents, [ToggleInsultVolumeEvent()]);
      }),
    );

    testWidgets(
      'Should display volume on icon by default',
      appHarness((given, when, then) async {
        await given.pumpWidget(const VolumeButton());

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) => widget is Icon && widget.icon == Icons.volume_up,
          ),
        );
      }),
    );

    testWidgets(
      'Should display volume off icon when state.areInsultsEnabled is false ',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const VolumeButton(),
          scoreboardState: initialScoreboardState.copyWith(
            areInsultsEnabled: false,
          ),
        );

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) => widget is Icon && widget.icon == Icons.volume_off,
          ),
        );
      }),
    );
  });
}
