// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/reset_game_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/volume_button.dart';

class ScoreboardPage extends StatelessWidget with NavigationMixin {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScoreboardPageDependencies(
      data: this,
      child: const ScoreboardView(),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.selectScoreboard.state.game;
    final round = game.round;
    final players = game.players;
    final strings = AppLocalizations.of(context);
    final roundWinnerText = round.roundWinner != null
        ? strings.playerNumber(round.roundWinner!.playerId)
        : '';

    return WillPopScope(
      onWillPop: () async {
        final shouldExitGame = await ScoreboardPageDependencies.of(context)
            ?.data
            .launchExitGameDialog(
              context,
              scoreboardBloc: context.readScoreboard,
            );
        return shouldExitGame ?? false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                // TODO(nibradshaw): this is just placeholder UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(strings.roundNumber(round.roundCount)),
                    Text(strings.roundWinner(roundWinnerText)),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(child: PlayerScore(player: players.first)),
                const SizedBox(height: 16),
                Expanded(child: PlayerScore(player: players[1])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: SettingsButton(context.readApp)),
                    const Flexible(child: ChangeTurnButton()),
                    const Flexible(child: VolumeButton()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerScore extends StatelessWidget {
  const PlayerScore({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final score = context
            .select((ScoreboardBloc bloc) => bloc.state.game)
            .players
            .firstWhereOrNull((p) => p.playerId == player.playerId)
            ?.score ??
        0;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(
              player.playerName,
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
            key: Key('scoreboard_gesture_player_${player.playerId}'),
            onLongPress: () async => _launchResetGameDialog(context),
            onTap: context.isGameOver
                ? null
                : () => context.readScoreboard.add(
                      IncreaseScoreEvent(playerId: player.playerId),
                    ),
            onVerticalDragEnd: context.isGameOver
                ? null
                : (DragEndDetails details) {
                    final primaryVelocity = details.primaryVelocity;
                    if (primaryVelocity != null) {
                      if (primaryVelocity < 0) {
                        context.readScoreboard.add(
                          IncreaseScoreEvent(playerId: player.playerId),
                        );
                      }
                      if (primaryVelocity > 0) {
                        context.readScoreboard.add(
                          DecreaseScoreEvent(playerId: player.playerId),
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
    );
  }
}

Future<void> _launchResetGameDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.selectScoreboard,
        child: const ResetGameDialog(),
      );
    },
  );
}
