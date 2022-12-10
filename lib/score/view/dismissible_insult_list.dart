import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: insults.isEmpty
              ? [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        context.l10n.emptyInsultsHint,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ]
              : [
                  Text(
                    context.l10n.customInsults,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...insults.map((e) {
                    final insult = e;
                    return Dismissible(
                      key: Key('insult_${insults.indexOf(e)}'),
                      onDismissed: (direction) {
                        bloc.add(
                          DeleteInsultEvent(insult),
                        );
                      },
                      background: deleteBackground(Alignment.centerLeft),
                      secondaryBackground:
                          deleteBackground(Alignment.centerRight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: kTextTabBarHeight,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Row(
                              children: [
                                const Text('•'),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    insult,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
        ),
      ),
    );
  }

  Widget deleteBackground(AlignmentGeometry alignmentGeometry) => ColoredBox(
        color: Colors.red,
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
