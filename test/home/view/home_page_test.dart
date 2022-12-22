// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/view/app.dart';
import 'package:smack_talking_scoreboard_v3/home/view/home_page.dart';
import 'package:smack_talking_scoreboard_v3/home/view/start_game_form.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

import '../../harness.dart';
import '../../score/view/scoreboard_page_objects.dart';

void main() {
  group('IntegrationTest', () {
    testWidgets(
      'Should properly populate correct number of default insults when App started',
      appHarness((given, when, then) async {
        await given.pumpWidget(const App());

        await when.userTaps(homePage.menuButton);
        await when.pumpAndSettle();

        await when.userTaps(homePage.menuItem(label: 'Manage Insults'));
        await when.pumpAndSettle();

        then.findsWidgets(find.byType(Dismissible), widgetCount: 23);
      }),
    );
  });

  group('HomePage', () {
    testWidgets(
      'Should launch StartGameDialog when hitting GetStartedButton',
      appHarness((given, when, then) async {
        await given.pumpWidget(const HomePage());

        await when.userTaps(homePage.getStartedButton);

        await when.pumpAndSettle();

        then.findsWidget(find.byType(StartGameForm));
      }),
    );

    group('Settings Popup', () {
      testWidgets(
        'Should launch Settings PopUp when hitting AppPopupMenuButton',
        appHarness((given, when, then) async {
          await given.pumpWidget(const HomePage());

          await when.userTaps(homePage.menuButton);

          await when.pumpAndSettle();

          then
            ..findsWidget(homePage.menuItem(label: 'Manage Insults'))
            ..findsWidget(homePage.menuItem(label: 'Add Insults'));
        }),
      );

      testWidgets(
        'Should launch AddInsultsBottomSheet when hitting AddInsults menu item',
        appHarness((given, when, then) async {
          await given.pumpWidget(const AppPopupMenuButton());

          await when.userTaps(find.byType(AppPopupMenuButton));
          await when.pumpAndSettle();

          await when.userTaps(homePage.menuItem(label: 'Add Insults'));
          await when.pumpAndSettle();

          then.findsWidget(homePage.addInsultsBottomSheet);
        }),
      );

      testWidgets(
        'Should launch ManageInsultsBottomSheet when hitting AddInsults menu item',
        appHarness((given, when, then) async {
          await given.pumpWidget(const AppPopupMenuButton());

          await when.userTaps(find.byType(AppPopupMenuButton));
          await when.pumpAndSettle();

          await when.userTaps(homePage.menuItem(label: 'Manage Insults'));
          await when.pumpAndSettle();

          then.findsWidget(homePage.manageInsultsBottomSheet);
        }),
      );
    });

    group('StartGameForm', () {
      testGoldens(
        'Should look right',
        appHarness((given, when, then) async {
          await given.pumpWidget(const StartGameForm());

          await then.multiScreenGoldensMatch(
            'start_game_form',
            devices: [
              Device.phone,
            ],
          );
        }),
      );

      testWidgets(
        "Should add StartGameEvent when hitting Let's go button with all valid form data",
        appHarness((given, when, then) async {
          await given.pumpWidget(const StartGameForm());

          await when.userTypes('User 1', homePage.player1TextInput);
          await when.userTypes('User 2', homePage.player2TextInput);
          await when.userTypes('1', homePage.winningScoreTextInput);
          await when.userTypes('2', homePage.winByTextInput);
          await when.userTypes('3', homePage.pointsPerScoreTextInput);

          await when.userTaps(homePage.letsGoButton);

          expect(then.harness.scoreBloc.addedEvents, [
            isAStartGameEvent
                .havingPlayer1(const Player(playerName: 'User 1', playerId: 1))
                .havingPlayer2(const Player(playerName: 'User 2', playerId: 2)),
          ]);
        }),
      );

      testWidgets(
        "Should display error text for each empty textInput when when hitting Let's go button",
        appHarness((given, when, then) async {
          await given.pumpWidget(const StartGameForm());

          await when.userTaps(homePage.letsGoButton);

          await when.pumpAndSettle();

          then.findsWidgets(
            find.text('Fill this out... dummy!'),
            widgetCount: 5,
          );

          expect(then.harness.scoreBloc.addedEvents, isEmpty);
        }),
      );
    });
  });
}

const isAStartGameEvent = TypeMatcher<StartGameEvent>();

extension on TypeMatcher<StartGameEvent> {
  TypeMatcher<StartGameEvent> havingPlayer1(Player player1) =>
      isAStartGameEvent.having((p0) => p0.player1, 'player1', player1);

  TypeMatcher<StartGameEvent> havingPlayer2(Player player2) =>
      isAStartGameEvent.having((p0) => p0.player2, 'player2', player2);
}
