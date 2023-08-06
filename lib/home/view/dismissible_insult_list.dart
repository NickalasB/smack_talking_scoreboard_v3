import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';

class DismissibleInsultList extends StatefulWidget {
  const DismissibleInsultList({super.key});

  @override
  State<DismissibleInsultList> createState() => _DismissibleInsultListState();
}

class _DismissibleInsultListState extends State<DismissibleInsultList> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.readApp;
    final insults = bloc.state.insults;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: insults.isEmpty
            ? [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      context.l10n.createInsultHint,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ]
            : [
                ...insults.map((insult) {
                  return Dismissible(
                    key: Key('insult_${insults.indexOf(insult)}'),
                    onDismissed: (direction) {
                      bloc.add(
                        DeleteInsultEvent(insult),
                      );
                    },
                    background: deleteBackground(
                      theme,
                      Alignment.centerLeft,
                    ),
                    secondaryBackground: deleteBackground(
                      theme,
                      Alignment.centerRight,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: kTextTabBarHeight,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  Text(
                                    '•',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 2),
                                  Flexible(
                                    child: Text.rich(
                                      replaceWordsWithStyledText(
                                        context,
                                        insult,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }),
              ],
      ),
    );
  }

  Widget deleteBackground(
    ThemeData theme,
    AlignmentGeometry alignmentGeometry,
  ) =>
      ColoredBox(
        color: theme.colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: alignmentGeometry,
            child: const Icon(
              Icons.delete,
            ),
          ),
        ),
      );
}

TextSpan replaceWordsWithStyledText(
  BuildContext context,
  String input, {
  required TextStyle textStyle,
}) {
  final children = <TextSpan>[];

  final theme = Theme.of(context);

  input.splitMapJoin(
    RegExp(r'##\w+##'),
    onMatch: (match) {
      final word = match.group(0) ?? '';
      if (word == hiPlayerInsultKey) {
        children.add(
          TextSpan(
            text: defaultHiText,
            style: textStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        );
      }
      if (word == lowPlayerInsultKey) {
        children.add(
          TextSpan(
            text: defaultLowText,
            style: textStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
        );
      }
      return '';
    },
    onNonMatch: (nonMatch) {
      children.add(TextSpan(text: nonMatch, style: textStyle));
      return '';
    },
  );

  return TextSpan(children: children);
}
