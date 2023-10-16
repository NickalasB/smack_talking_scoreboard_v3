import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
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
        await given.appState(
          const AppState(
            availableVoices: [Voice(name: 'name', locale: 'locale')],
          ),
        );
        await given.pumpWidget(
          const SelectVoicesButton(),
        );
        await tick();

        then.findsWidget(page.setVoicesButton);
      }),
    );

    testWidgets(
      'Should launch select voices bottom sheet when pressed',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ScoreboardView(),
          appState: const AppState(
            availableVoices: [Voice(name: 'name', locale: 'locale')],
          ),
        );

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
        await given.pumpWidget(const ScoreboardView());
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
                  'Well. Are you going to just pick your nose or actually pick a voice here?',
            ),
          ],
        );
      }),
    );

    testGoldens(
      'Should show ListTile in selected state when voice is selected',
      appHarness((given, when, then) async {
        const appState = AppState(
          availableVoices: [
            Voice(name: 'name', locale: 'locale'),
            Voice(name: 'name2', locale: 'locale'),
          ],
          selectedVoice: Voice(name: 'name2', locale: 'locale'),
        );
        await given.appState(appState);
        await given.pumpWidget(const ScoreboardView());
        await tick();

        await when.userTaps(page.setVoicesButton);
        await when.pumpAndSettle();

        await then.screenMatchesGoldenFile('select_voice_list_selected');
        then.findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ListTile &&
                widget.title is Text &&
                (widget.title! as Text).data == 'Voice # 1' &&
                widget.selected == true,
          ),
        );

        when.harness.appBloc.emit(
          appState.copyWith(
            selectedVoice: const Voice(name: 'name', locale: 'locale'),
          ),
        );
        await when.pumpAndSettle();

        then.findsWidget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ListTile &&
                widget.title is Text &&
                (widget.title! as Text).data == 'Voice # 0' &&
                widget.selected == true,
          ),
        );
      }),
    );
  });
}
