import 'package:flutter/cupertino.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

List<String> localizedDefaultInsults(
  BuildContext context, {
  required int maxDefaultInsultIndex,
}) {
  final l10n = context.l10n;

  final insultList = <String>[];
  for (var i = 0; i <= maxDefaultInsultIndex; i++) {
    insultList.add(l10n.insult(i.toString()));
  }

  return insultList;
}

List<String> localizedDefaultTieInsults(
  BuildContext context, {
  required int maxDefaultTieInsultIndex,
}) {
  final l10n = context.l10n;

  final insultList = <String>[];
  for (var i = 0; i <= maxDefaultTieInsultIndex; i++) {
    insultList.add(l10n.tieGameInsult(i.toString()));
  }

  return insultList;
}
