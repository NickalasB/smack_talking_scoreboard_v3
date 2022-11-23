import 'package:flutter/cupertino.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

List<String> localizedDefaultInsults(
  BuildContext context, {
  required int insultListLength,
}) {
  final l10n = context.l10n;

  final insultList = <String>[];
  for (var i = 0; i <= insultListLength; i++) {
    insultList.add(l10n.insult(i));
  }

  return insultList;
}
