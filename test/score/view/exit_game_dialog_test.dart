import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';

import '../../harness.dart';

void main() {
  group('ExitGameDialog', () {
    testGoldens(
      'Should look right',
      appHarness((given, when, then) async {
        await given.pumpWidget(ExitGameDialog());

        await then.multiScreenGoldensMatch(
          'exit_screen_dialog',
          devices: [Device.phone],
        );
      }),
    );
  });
}
