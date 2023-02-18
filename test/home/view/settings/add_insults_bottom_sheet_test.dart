// ignore_for_file:avoid_redundant_argument_values

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/home/view/home_page.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../../harness.dart';
import '../home_page_objects.dart';

void main() {
  testWidgets(
    'Should show tool tips when user taps draggable HI or LOW',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.hiDraggable);
      await when.pumpAndSettle();

      then.findsWidget(
        addInsultPage.toolTipMessage(
          "Drag me to the HI/LOW above to insert the HI scorer's name",
        ),
      );

      await when.userTaps(addInsultPage.lowDraggable);
      await when.pumpAndSettle();

      then.findsWidget(
        addInsultPage.toolTipMessage(
          "Drag me to the HI/LOW above to insert the LOW scorer's name",
        ),
      );
    }),
  );

  testWidgets(
    'Should disable Done button and Listen button when no insults have been added',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AddInsultsBottomSheet());

      await when.pumpAndSettle();

      then
        ..findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is PrimaryButton &&
                widget.key == const Key('save_button') &&
                widget.onPressed == null,
          ),
        )
        ..findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is PrimaryButton &&
                widget.key == const Key('listen_button') &&
                widget.onPressed == null,
          ),
        );
    }),
  );

  testWidgets(
    'Should add SaveInsultEvent when hitting dialog save button',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await when.userTypes('anything', addInsultPage.insultTextField());
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(),
      );

      await when.userTaps(addInsultPage.saveButton);
      await when.pumpAndSettle();

      await when.idle();

      then.addedAppBlocEvents(
        containsAll([SaveInsultEvent(r'$HI$ anything')]),
      );
    }),
  );

  testWidgets(
    'Should reset HI/LOW drag target when user drags draggable to target but moves off target',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await when.userTypes('anything', addInsultPage.insultTextField());
      await when.pumpAndSettle();

      await when.userDragsWidgetToTargetThenOffTarget(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(),
      );

      then.findsWidget(
        find.byWidgetPredicate(
          (widget) =>
              widget is PrimaryButton &&
              widget.key == const Key('save_button') &&
              widget.onPressed == null,
        ),
      );
    }),
  );

  testWidgets(
    'Should save insult in correct order regardless of order of adding text/hi/low',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());
      await when.pumpAndSettle();

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTypes('0', addInsultPage.insultTextField(at: 0));
      await when.pumpAndSettle();

      await when.userTypes('3', addInsultPage.insultTextField(at: 3));
      await when.pumpAndSettle();

      await when.userTypes('1', addInsultPage.insultTextField(at: 1));
      await when.pumpAndSettle();

      await when.userTypes('2', addInsultPage.insultTextField(at: 2));
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.lowDraggable,
        target: addInsultPage.hiLowDragTarget(at: 1),
      );

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(at: 3),
      );

      await when.userDragsWidgetTo(
        draggable: addInsultPage.lowDraggable,
        target: addInsultPage.hiLowDragTarget(at: 2),
      );

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(at: 0),
      );

      await when.userTaps(addInsultPage.saveButton);
      await when.pumpAndSettle();

      then.addedAppBlocEvents(
        containsAll(
          [SaveInsultEvent(r'$HI$ 0 $LOW$ 1 $LOW$ 2 $HI$ 3')],
        ),
      );
    }),
  );

  testWidgets(
    'Should add SpeakInsultEvent when hitting listen button',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await when.userTypes('anything', addInsultPage.insultTextField());
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(),
      );

      await when.userTaps(addInsultPage.listenButton);
      await when.pumpAndSettle();

      await when.idle();

      then.addedScoreBlocEvents(
        containsAll([SpeakInsultEvent(r'$HI$ anything')]),
      );
    }),
  );

  testWidgets(
    'Should remove last insult string when hitting undo button',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AddInsultsBottomSheet());
      await when.pumpAndSettle();

      await when.userTypes('anything', addInsultPage.insultTextField());
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(),
      );

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userTypes(
        'I should be deleted when undo button is pressed',
        addInsultPage.insultTextField(at: 1),
      );
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.lowDraggable,
        target: addInsultPage.hiLowDragTarget(at: 1),
      );

      then.addedInsultCreatorEvents(
        const TypeMatcher<List<InsultCreatorEvent>>().having(
          (p0) => p0.last,
          'lastEvent',
          CreateInsultEvent(
            r'$LOW$ I should be deleted when undo button is pressed',
            index: 1,
          ),
        ),
      );

      await when.userTaps(addInsultPage.undoInsultButton);
      await when.pumpAndSettle();

      then.addedInsultCreatorEvents(
        const TypeMatcher<List<InsultCreatorEvent>>().having(
          (p0) => p0.last,
          'lastEvent',
          CreateInsultEvent('', index: 1),
        ),
      );
    }),
  );
}
