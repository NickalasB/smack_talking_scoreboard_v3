import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';

class ScoreBoardPageObject extends PageObject {
  ScoreBoardPageObject() : super(find.byType(ScoreboardPage));

  Finder playerScore({required int forPlayerId}) =>
      find.byKey(Key('scoreboard_gesture_player_$forPlayerId'));
}
