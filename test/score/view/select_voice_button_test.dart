import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/select_voice_button.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

import '../../harness.dart';
import '../../helpers/test_helpers.dart';
import 'scoreboard_page_objects.dart';

void main() {
  final page = ScoreBoardPageObject();
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
        await given.appState(const AppState(
            availableVoices: [Voice(name: 'name', locale: 'locale')]));
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        then.findsWidget(page.setVoicesButton);
      }),
    );

    testWidgets(
      'Should launch select voices bottom sheet when pressed',
      appHarness((given, when, then) async {
        await given.appState(
          const AppState(
            availableVoices: [Voice(name: 'name', locale: 'locale')],
          ),
        );
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        await when.userTaps(page.setVoicesButton);
        await when.pumpAndSettle();

        then.findsWidget(page.selectVoicesBottomSheet);
      }),
    );

    testWidgets(
      'Should Add SetVoiceEvent and speak sample insult when selecting a voice',
      appHarness((given, when, then) async {
        await given.appState(
          const AppState(
            availableVoices: [
              Voice(name: 'name', locale: 'locale'),
              Voice(name: 'name2', locale: 'locale'),
            ],
          ),
        );
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        await when.userTaps(page.setVoicesButton);
        await when.pumpAndSettle();

        await when.userTaps(find.byType(ListTile).at(0));
        await when.pumpAndSettle();
        await tick();

        then.addedAppBlocEvents(
          [
            SetVoiceEvent(
              const Voice(name: 'name', locale: 'locale'),
              sampleInsult:
                  "Well. This is what it will sound like when you're getting insulted. Idiot",
            ),
          ],
        );
      }),
    );

    testWidgets(
      'Should show ListTile in selected state when voice is selected',
      appHarness((given, when, then) async {
        await given.appState(
          const AppState(
            availableVoices: [
              Voice(name: 'name', locale: 'locale'),
              Voice(name: 'name2', locale: 'locale'),
            ],
            selectedVoice: Voice(name: 'name2', locale: 'locale'),
          ),
        );
        await given.pumpWidget(const SelectVoicesButton());
        await tick();

        await when.userTaps(page.setVoicesButton);
        await when.pumpAndSettle();

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) => widget is ListTile && widget.selected == true,
          ),
        );
      }),
    );
  });
}
