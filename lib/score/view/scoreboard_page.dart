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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(child: PlayerScore(playerId: 1)),
              SizedBox(height: 16),
              Expanded(child: PlayerScore(playerId: 2)),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('increase_button'),
            onPressed: () =>
                context.read<ScoreBloc>().add(IncreaseScoreEvent()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('decrease_button'),
            onPressed: () =>
                context.read<ScoreBloc>().add(DecreaseScoreEvent()),
            child: const Icon(Icons.remove),
          ),
        ],
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
    final score = context.select((ScoreBloc bloc) => bloc.state.score);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
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
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Center(
                child: Text(
                  score.toString(),
                  style: TextStyle(fontSize: 260),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
