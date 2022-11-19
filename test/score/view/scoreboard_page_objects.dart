import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';

class ScoreBoardPageObject extends PageObject {
  ScoreBoardPageObject() : super(find.byType(ScoreboardPage));

  Finder playerScore({required int forPlayerId}) =>
      find.byKey(Key('scoreboard_gesture_player_$forPlayerId'));

  Finder get settingsButton => find.byKey(const Key('settings_button'));

  Finder get settingsBottomSheet =>
      find.byKey(const Key('settings_bottom_sheet'));

  Finder insultTextField({int at = 0}) =>
      find.byKey(Key('insult_text_field_$at'));

  Finder get changeTurnButton => find.byType(ChangeTurnButton);

  Finder get resetScoreDialog => find.byKey(const Key('reset_score_dialog'));

  Finder get doneButton => find.byKey(const Key('done_button'));

  Finder get addMoreInsultButton =>
      find.byKey(const Key('add_more_insult_text_button'));

  Finder hiLowDragTarget({int at = 0}) =>
      find.byKey(Key('hi_low_drag_target_$at'));

  Finder get hiDraggable => find.byKey(const Key('hi_draggable'));

  Finder get lowDraggable => find.byKey(const Key('low_draggable'));
}
