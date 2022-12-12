// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/app.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

import '../../harness.dart';
import '../../score/view/scoreboard_page_objects.dart';

void main() {
  group('App', () {
    testWidgets(
      'should render FirstScreen when App launched',
      appHarness((given, when, then) async {
        await given.pumpWidget(const App());
        then.findsWidget(find.byType(FirstScreen));
      }),
    );

    testWidgets(
      'should render HomePage when game is not in Progress',
      appHarness((given, when, then) async {
        await given.scoreBoardState(
          initialScoreboardState.copyWith(isGameInProgress: false),
        );
        await when.pumpAndSettle();

        await given.pumpWidget(const FirstScreen());

        then.findsWidget(homePage);
      }),
    );

    testWidgets(
      'should render ScoreboardPage when game is in Progress',
      appHarness((given, when, then) async {
        await given.scoreBoardState(
          initialScoreboardState.copyWith(isGameInProgress: true),
        );
        await when.pumpAndSettle();

        await given.pumpWidget(const FirstScreen());

        then.findsWidget(scoreboardPage);
      }),
    );
  });
}
