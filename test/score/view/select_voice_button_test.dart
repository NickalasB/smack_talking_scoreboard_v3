import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/select_voice_button.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Select Voices Button', () {
    testWidgets(
      'Should hide button if no available voices',
      appHarness((given, when, then) async {
        // ignore: avoid_redundant_argument_values
        await given.appState(const AppState(availableVoices: []));
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        then.findsWidget(find.byKey(const Key('empty_voices_shrink_box')));
      }),
    );

    testWidgets(
      'Should show button if available voices is not empty',
      appHarness((given, when, then) async {

        await given.appState(const AppState(availableVoices: [Voice(name: 'name', locale: 'locale')]));
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        then.findsWidget(find.byKey(const Key('select_voice_button')));
      }),
    );
  });
}
