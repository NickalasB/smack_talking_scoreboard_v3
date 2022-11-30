// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/view/app.dart';

import 'harness.dart';
import 'score/view/scoreboard_page_objects.dart';

void main() {
  group('DefaultInsults', () {
    /// This needs to be more of an integration test since I am creating a fake
    /// ScoreBloc for other tests
    testWidgets(
      'Should properly populate correct number of default insults when game created',
      appHarness((given, when, then) async {
        await given.harness.tester.pumpWidget(const App());

        await when.userTaps(homePage.getStartedButton);
        await when.pumpAndSettle();

        await when.userTypes('User 1', homePage.player1TextInput);
        await when.userTypes('User 2', homePage.player2TextInput);
        await when.userTypes('1', homePage.winningScoreTextInput);
        await when.userTypes('2', homePage.winByTextInput);
        await when.userTypes('3', homePage.pointsPerScoreTextInput);

        await when.userTaps(homePage.letsGoButton);
        await when.pumpAndSettle();

        await when.userTaps(scoreboardPage.settingsButton);
        await when.pumpAndSettle();

        then.findsWidgets(find.byType(Dismissible), widgetCount: 23);
      }),
    );
  });
}
