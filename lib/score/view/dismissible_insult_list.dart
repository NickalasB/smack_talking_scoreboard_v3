import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

class DismissibleInsultList extends StatefulWidget {
  const DismissibleInsultList({super.key});

  @override
  State<DismissibleInsultList> createState() => _DismissibleInsultListState();
}

class _DismissibleInsultListState extends State<DismissibleInsultList> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.readScoreboard;
    final insults = bloc.state.insults;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                secondaryBackground: deleteBackground(Alignment.centerRight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: kTextTabBarHeight,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        insult,
                        style: theme.textTheme.bodyLarge,
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
