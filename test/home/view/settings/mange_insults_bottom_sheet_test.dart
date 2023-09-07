import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/home/view/dismissible_insult_list.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings.dart';

import '../../../harness.dart';

void main() {
  group('Manage Insults BottomSheet', () {
    testWidgets(
      'Should add DeleteInsultEvent when user swipes insult from Settings BottomSheet',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ManageInsultsBottomSheet(),
          appState: const AppState().copyWith(
            insults: [
              'insult1',
              'insult2',
            ],
          ),
        );
        await when.pumpAndSettle();

        then.findsWidget(find.text('insult1'));

        await when.userSwipesHorizontally(find.text('insult1'));
        await when.pumpAndSettle();

        then
          ..addedAppBlocEvents(
            containsAll([DeleteInsultEvent('insult1')]),
          )
          ..findsNoWidget(find.text('insult1'));
      }),
    );

    testWidgets(
      'Should show empty state text when user has no insults',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          const ManageInsultsBottomSheet(),
          appState: const AppState().copyWith(
            insults: [],
          ),
        );
        await when.pumpAndSettle();

        then.findsWidget(
          find.text(
            'Good job! You deleted all the insults and disabled the only cool thing about this lame app!',
          ),
        );
      }),
    );

    testGoldens(
      'Should properly replace and style instances of ##HIGH## and ##LOW## within insults',
      appHarness((given, when, then) async {
        await given.pumpWidgetWithState(
          DismissibleInsultList(
            names: List.generate(150, (index) => 'PlayerName'),
          ),
          appState: const AppState().copyWith(
            insults: [
              ' ##HIGH## you are awesome. ##LOW## you are poop',
              'Nothing to replace or style here'
            ],
          ),
        );
        await when.pumpAndSettle();

        await then.multiScreenGoldensMatch(
          'styled_insults',
          devices: [
            Device.phone,
            Device.phone.dark(),
          ],
        );
      }),
    );

    for (final brightness in Brightness.values) {
      testGoldens(
        'Should display correct background color and icon when user swipes insult LEFT from Settings BottomSheet_${brightness.name}',
        appHarness((given, when, then) async {
          await given.pumpWidgetWithState(
            const ManageInsultsBottomSheet(),
            appState: const AppState().copyWith(
              insults: [
                'insult1',
              ],
            ),
            brightness: brightness,
          );
          await when.pumpAndSettle();

          then.findsWidget(find.text('insult1'));

          await when.userSwipesHorizontally(find.text('insult1'), dx: -500);

          await then.multiScreenGoldensMatch(
            'swipe_to_delete_insult_left',
            shouldSkipPumpAndSettle: true,
            devices: [Device.phone.copyWith(name: 'phone_${brightness.name}')],
          );
        }),
      );
    }

    for (final brightness in Brightness.values) {
      testGoldens(
        'Should display correct background color and icon when user swipes insult RIGHT from Settings BottomSheet_${brightness.name}',
        appHarness((given, when, then) async {
          await given.pumpWidgetWithState(
            const ManageInsultsBottomSheet(),
            appState: const AppState().copyWith(
              insults: [
                'insult1',
              ],
            ),
            brightness: brightness,
          );
          await when.pumpAndSettle();

          then.findsWidget(find.text('insult1'));

          await when.userSwipesHorizontally(find.text('insult1'), dx: 500);

          await then.multiScreenGoldensMatch(
            'swipe_to_delete_insult_right',
            shouldSkipPumpAndSettle: true,
            devices: [Device.phone.copyWith(name: 'phone_${brightness.name}')],
          );
        }),
      );
    }
  });
}
