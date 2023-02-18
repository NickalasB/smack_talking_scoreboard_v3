import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:smack_talking_scoreboard_v3/home/view/home_page.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings.dart';

final addInsultPage = AddInsultPage();
final homePage = HomePageObjects();

class AddInsultPage extends PageObject {
  AddInsultPage() : super(find.byType(AddInsultsBottomSheet));

  Finder get undoInsultButton => find.byKey(const Key('insult_undo_button'));

  Finder get createInsultHint => find.byKey(const Key('create_insult_hint'));

  Finder toolTipMessage(String message) => find.byWidgetPredicate(
        (widget) => widget is Tooltip && widget.message == message,
      );

  Finder get saveButton => find.byKey(const Key('save_button'));

  Finder get listenButton => find.byKey(const Key('listen_button'));

  Finder get addMoreInsultButton =>
      find.byKey(const Key('add_more_insult_text_button'));

  Finder hiLowDragTarget({int at = 0}) =>
      find.byKey(Key('hi_low_drag_target_$at'));

  Finder insultTextField({int at = 0}) =>
      find.byKey(Key('insult_text_field_$at'));

  Finder get hiDraggable => find.byKey(const Key('hi_draggable'));

  Finder get lowDraggable => find.byKey(const Key('low_draggable'));
}

class HomePageObjects extends PageObject {
  HomePageObjects() : super(find.byType(HomePage));

  Finder get menuButton => find.byKey(const Key('menu_button'));

  Finder menuItem({required String label}) => find.byWidgetPredicate(
        (widget) => widget is PopupMenuItem<String> && widget.value == label,
      );

  Finder get addInsultsBottomSheet =>
      find.byKey(const Key('add_insults_bottom_sheet'));

  Finder get manageInsultsBottomSheet =>
      find.byKey(const Key('mange_insults_bottom_sheet'));

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
