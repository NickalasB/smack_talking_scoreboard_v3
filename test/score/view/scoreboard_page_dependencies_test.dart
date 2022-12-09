import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
  testWidgets(
    'Should NOT update widget when data is the same',
    appHarness((given, when, then) async {
      expect(
        given.dependencies1.updateShouldNotify(given.dependencies1),
        isFalse,
      );
    }),
  );

  testWidgets(
    'Should update widget when data is NOT the same',
    appHarness((given, when, then) async {
      expect(
        given.dependencies1.updateShouldNotify(
          const ScoreboardPageDependencies(
            data: _TestScoreboardDependencies(),
            child: Placeholder(),
          ),
        ),
        isTrue,
      );
    }),
  );

  testWidgets(
    'Should launch ExitGameDialog when launchExitGameDialog called',
    appHarness((given, when, then) async {
      await given.pumpWidget(
        const _TestScoreboardDependencies(),
      );

      await when.userTaps(find.byType(PrimaryButton));
      await tick();
      await when.pumpAndSettle();

      then.findsWidget(exitGameDialogPage);
    }),
  );
}

extension on WidgetTestGiven<AppHarness> {
  ScoreboardPageDependencies get dependencies1 => ScoreboardPageDependencies(
        data: harness,
        child: const Placeholder(),
      );
}

class _TestScoreboardDependencies extends StatelessWidget with NavigationMixin {
  const _TestScoreboardDependencies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScoreboardPageDependencies(
        data: this,
        child: Builder(
          builder: (context) {
            return PrimaryButton(
              label: 'test',
              onPressed: () async {
                await ScoreboardPageDependencies.of(context)
                    ?.data
                    .launchExitGameDialog(
                      context,
                      scoreboardBloc: FakeScoreBloc(initialScoreboardState),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}
