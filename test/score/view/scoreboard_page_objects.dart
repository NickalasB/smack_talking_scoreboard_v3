import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:smack_talking_scoreboard_v3/home/view/home_page.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';

final scoreboardPage = ScoreBoardPageObject();

class ScoreBoardPageObject extends PageObject {
  ScoreBoardPageObject() : super(find.byType(ScoreboardPage));

  Finder playerScore({required int forPlayerId}) =>
      find.byKey(Key('scoreboard_gesture_player_$forPlayerId'));

  Finder get settingsButton => find.byKey(const Key('settings_button'));

  Finder get volume => find.byKey(const Key('volume_button'));

  Finder get settingsBottomSheet =>
      find.byKey(const Key('settings_bottom_sheet'));

  Finder insultTextField({int at = 0}) =>
      find.byKey(Key('insult_text_field_$at'));

  Finder get changeTurnButton => find.byType(ChangeTurnButton);

  Finder get resetScoreDialog => find.byKey(const Key('reset_score_dialog'));

  Finder get gameWinnerDialog => find.byKey(const Key('game_winner_dialog'));

  Finder get doneButton => find.byKey(const Key('done_button'));

  Finder get addMoreInsultButton =>
      find.byKey(const Key('add_more_insult_text_button'));

  Finder hiLowDragTarget({int at = 0}) =>
      find.byKey(Key('hi_low_drag_target_$at'));

  Finder get hiDraggable => find.byKey(const Key('hi_draggable'));

  Finder get lowDraggable => find.byKey(const Key('low_draggable'));
}

final homePage = HomePageObjects();

class HomePageObjects extends PageObject {
  HomePageObjects() : super(find.byType(HomePage));

  Finder get getStartedButton => find.byKey(const Key('get_started_button'));

  Finder get letsGoButton => find.byKey(const Key('lets_go_button'));

  Finder get winByTextInput =>
      find.byKey(const Key('win_by_margin_form_field'));

  Finder get pointsPerScoreTextInput => find.byKey(
        const Key('points_per_score_form_field'),
      );

  Finder get winningScoreTextInput => find.byKey(
        const Key('winning_score_form_field'),
      );

  Finder get player2TextInput => find.byKey(
        const Key('player_2_form_field'),
      );

  Finder get player1TextInput => find.byKey(
        const Key('player_1_form_field'),
      );
}
