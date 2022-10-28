// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/app.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

void main() {
  group('App', () {
    testWidgets('renders ScoreboardPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(ScoreboardPage), findsOneWidget);
    });
  });
}
