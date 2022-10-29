// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ftw_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/speak_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/volume_button.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoreBloc(),
      child: const ScoreboardView(),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Expanded(child: PlayerScore(playerId: 1)),
            const SizedBox(height: 16),
            const Expanded(child: PlayerScore(playerId: 2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(child: FtwButton()),
                  Flexible(child: SpeakButton()),
                  Flexible(child: VolumeButton()),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       key: const Key('increase_button'),
      //       onPressed: () =>
      //           context.read<ScoreBloc>().add(IncreaseScoreEvent()),
      //       child: const Icon(Icons.add),
      //     ),
      //     const SizedBox(height: 8),
      //     FloatingActionButton(
      //       key: const Key('decrease_button'),
      //       onPressed: () =>
      //           context.read<ScoreBloc>().add(DecreaseScoreEvent()),
      //       child: const Icon(Icons.remove),
      //     ),
      //   ],
      // ),
    );
  }
}

class PlayerScore extends StatelessWidget {
  const PlayerScore({super.key, required this.playerId});

  final int playerId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final score = context.select((ScoreBloc bloc) => bloc.state.score);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: Text(
                l10n.player1(playerId),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: FittedBox(
                child: Text(
                  score.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
