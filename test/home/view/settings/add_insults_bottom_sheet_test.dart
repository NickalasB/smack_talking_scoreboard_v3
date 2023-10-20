// ignore_for_file:avoid_redundant_argument_values

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/home/view/home_page.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings/add_insults_bottom_sheet.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../../harness.dart';
import '../home_page_objects.dart';

void main() {
  testGoldens(
    'Should look right',
    appHarness((given, when, then) async {
      await given.pumpWidget(const AppPopupMenuButton());

      await when.userTaps(find.byType(AppPopupMenuButton));
      await when.pumpAndSettle();

      await when.userTaps(homePage.menuItem(label: 'Add Insults'));
      await when.pumpAndSettle();

      await then.multiScreenGoldensMatch('add_insult_bottom_sheet');
    }),
  );

  testWidgets(
    'Bottom sheet should be FractionallySizedBox with a height factor of .5 when Bottom View Inset is 0 (Keyboard is hidden)',
    appHarness((given, when, then) async {
      await given.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            viewInsets: EdgeInsets.zero,
          ),
          child: AddInsultsBottomSheet(),
        ),
      );

      then.findsWidget(
        find.byWidgetPredicate(
          (widget) =>
              widget is FractionallySizedBox && widget.heightFactor == .5,
        ),
      );
    }),
  );

  testWidgets(
    'Bottom sheet should be FractionallySizedBox with a height factor of .90 when Bottom View Inset is NOT 0 (Keyboard is visible)',
    appHarness((given, when, then) async {
      await given.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            viewInsets: EdgeInsets.only(bottom: 100),
          ),
          child: AddInsultsBottomSheet(),
        ),
      );

      then.findsWidget(
        find.byWidgetPredicate(
          (widget) =>
              widget is FractionallySizedBox && widget.heightFactor == .90,
        ),
      );
    }),
  );

  testWidgets(
    'Should show tool tips when user taps draggable HIGH or LOW',
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
          "Drag me to the HIGH/LOW above to insert the HIGH scorer's name",
        ),
      );

      await when.userTaps(addInsultPage.lowDraggable);
      await when.pumpAndSettle();

      then.findsWidget(
        addInsultPage.toolTipMessage(
          "Drag me to the HIGH/LOW above to insert the LOW scorer's name",
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
        containsAll([SaveInsultEvent('##HIGH## anything')]),
      );
    }),
  );

  testWidgets(
    'Should reset HIGH/LOW drag target when user drags draggable to target but moves off target',
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
          [SaveInsultEvent('##HIGH## 0 ##LOW## 1 ##LOW## 2 ##HIGH## 3')],
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
        containsAll([SpeakInsultEvent('##HIGH## anything')]),
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
            '##LOW## I should be deleted when undo button is pressed',
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
          RemoveLastInsultAdditionEvent(),
        ),
      );
    }),
  );

  testGoldens(
    'Should properly build complex insult',
    appHarness((given, when, then) async {
      await given.pumpWidget(
        const AddInsultsBottomSheet(),
      );
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.lowDraggable,
        target: addInsultPage.hiLowDragTarget(),
      );

      await when.userTypes('first', addInsultPage.insultTextField());
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.lowDraggable,
        target: addInsultPage.hiLowDragTarget(at: 1),
      );
      await when.pumpAndSettle();

      await when.userTypes(
        'second',
        addInsultPage.insultTextField(at: 1),
      );
      await when.pumpAndSettle();

      await when.userTaps(addInsultPage.addMoreInsultButton);
      await when.pumpAndSettle();

      await when.userDragsWidgetTo(
        draggable: addInsultPage.hiDraggable,
        target: addInsultPage.hiLowDragTarget(at: 2),
      );
      await when.pumpAndSettle();

      await when.userTypes(
        'third',
        addInsultPage.insultTextField(at: 2),
      );
      await when.pumpAndSettle();

      await then.screenMatchesGoldenFile('complex_insult');
    }),
  );
}
