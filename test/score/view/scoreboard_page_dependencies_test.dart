import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
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

class _TestScoreboardDependencies extends StatelessWidget with NavigationMixin {
  const _TestScoreboardDependencies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScoreboardPageDependencies(
        data: this,
        child: Builder(builder: (context) {
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
        }),
      ),
    );
  }
}
