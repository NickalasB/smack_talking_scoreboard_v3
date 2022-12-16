// ignore_for_file:avoid_redundant_argument_values

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../harness.dart';
import 'scoreboard_page_objects.dart';

void main() {
  testWidgets(
    'Should disable Done button when no insults have been added',
    appHarness((given, when, then) async {
      await given.pumpWidget(SettingsButton(given.harness.appBloc));

      await when.userTaps(scoreboardPage.settingsButton);
      await when.pumpAndSettle();
      await when.pumpAndSettle();

      then.findsWidget(
        find.byWidgetPredicate(
          (widget) =>
              widget is PrimaryButton &&
              widget.key == const Key('done_button') &&
              widget.onPressed == null,
        ),
      );
    }),
  );

  testWidgets(
    'Should add SaveInsultEvent when hitting dialog done button',
    appHarness((given, when, then) async {
      await given.pumpWidget(SettingsButton(given.harness.appBloc));

      await when.userTaps(scoreboardPage.settingsButton);
      await when.pumpAndSettle();

      then.findsWidget(scoreboardPage.settingsBottomSheet);

      await when.userTypes('anything', scoreboardPage.insultTextField());
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: scoreboardPage.hiDraggable,
        target: scoreboardPage.hiLowDragTarget(),
      );

      await when.userTaps(scoreboardPage.doneButton);
      await when.pumpAndSettle();

      await when.idle();

      then.addedAppBlocEvents(
        containsAll([SaveInsultEvent(r'$HI$ anything')]),
      );
    }),
  );

  testWidgets(
    'Should save insult in correct order regardless of order of adding text/hi/low',
    appHarness((given, when, then) async {
      await given.pumpWidget(SettingsButton(given.harness.appBloc));

      await when.userTaps(scoreboardPage.settingsButton);
      await when.pumpAndSettle();

      await when.userTaps(scoreboardPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTaps(scoreboardPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTaps(scoreboardPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTypes('0', scoreboardPage.insultTextField(at: 0));
      await when.pumpAndSettle();

      await when.userTypes('3', scoreboardPage.insultTextField(at: 3));
      await when.pumpAndSettle();

      await when.userTypes('1', scoreboardPage.insultTextField(at: 1));
      await when.pumpAndSettle();

      await when.userTypes('2', scoreboardPage.insultTextField(at: 2));
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: scoreboardPage.lowDraggable,
        target: scoreboardPage.hiLowDragTarget(at: 1),
      );

      await when.userDragsWidgetTo(
        draggable: scoreboardPage.hiDraggable,
        target: scoreboardPage.hiLowDragTarget(at: 3),
      );

      await when.userDragsWidgetTo(
        draggable: scoreboardPage.lowDraggable,
        target: scoreboardPage.hiLowDragTarget(at: 2),
      );

      await when.userDragsWidgetTo(
        draggable: scoreboardPage.hiDraggable,
        target: scoreboardPage.hiLowDragTarget(at: 0),
      );

      await when.userTaps(scoreboardPage.doneButton);
      await when.pumpAndSettle();

      then.addedAppBlocEvents(
        containsAll(
          [SaveInsultEvent(r'$HI$ 0 $LOW$ 1 $LOW$ 2 $HI$ 3')],
        ),
      );
    }),
  );
}
