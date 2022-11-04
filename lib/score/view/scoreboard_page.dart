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
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ftw_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/speak_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/volume_button.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoreboardBloc(),
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
    );
  }
}

class PlayerScore extends StatelessWidget {
  const PlayerScore({super.key, required this.playerId});

  final int playerId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final score = context
            .select((ScoreboardBloc bloc) => bloc.state.game)
            .players[playerId]
            ?.score ??
        0;
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
            child: GestureDetector(
              key: Key('scoreboard_gesture_player_$playerId'),
              onTap: () => context
                  .addScoreboardEvent(IncreaseScoreEvent(playerId: playerId)),
              onVerticalDragEnd: (DragEndDetails details) {
                final primaryVelocity = details.primaryVelocity;
                if (primaryVelocity != null) {
                  if (primaryVelocity < 0) {
                    context.addScoreboardEvent(
                      IncreaseScoreEvent(playerId: playerId),
                    );
                  }
                  if (primaryVelocity > 0) {
                    context.addScoreboardEvent(
                      DecreaseScoreEvent(playerId: playerId),
                    );
                  }
                }
              },
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
          ),
        ],
      ),
    );
  }
}
