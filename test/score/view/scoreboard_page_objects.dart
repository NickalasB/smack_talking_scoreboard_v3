import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/game_winner_dialog.dart';

final scoreboardPage = ScoreBoardPageObject();
final gameWinnerDialogPage = GameWinnerDialogPageObject();
final exitGameDialogPage = ExitGameDialogPageObject();

class ScoreBoardPageObject extends PageObject {
  ScoreBoardPageObject() : super(find.byType(ScoreboardPage));

  Finder playerScore({required int forPlayerId}) =>
      find.byKey(Key('scoreboard_gesture_player_$forPlayerId'));

  Finder get settingsButton => find.byKey(const Key('settings_button'));

  Finder get volume => find.byKey(const Key('volume_button'));

  Finder get setVoicesButton => find.byKey(const Key('select_voice_button'));

  Finder get selectVoicesBottomSheet =>
      find.byKey(const Key('select_voices_bottom_sheet'));

  // TODO(nibradshaw): delete these as they now belong to HomePage
  Finder get addInsultsBottomSheet =>
      find.byKey(const Key('add_insults_bottom_sheet'));

  Finder get manageInsultsBottomSheet =>
      find.byKey(const Key('mange_insults_bottom_sheet'));

  Finder get changeTurnButton => find.byKey(const Key('change_turn_button'));

  Finder get resetScoreDialog => find.byKey(const Key('reset_score_dialog'));

  Finder get gameWinnerDialog => gameWinnerDialogPage;
}

class GameWinnerDialogPageObject extends PageObject {
  GameWinnerDialogPageObject() : super(find.byType(GameWinnerDialog));

  Finder get yesButton => find.byKey(const Key('game_winner_yes_button'));

  Finder get noButton => find.byKey(const Key('game_winner_no_button'));
}

class ExitGameDialogPageObject extends PageObject {
  ExitGameDialogPageObject() : super(find.byType(ExitGameDialog));

  Finder get yesButton => find.byKey(const Key('exit_game_yes_button'));

  Finder get noButton => find.byKey(const Key('exit_game_no_button'));
}
