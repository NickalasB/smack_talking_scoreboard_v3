// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/reset_game_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/score/view/select_voice_button.dart';
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
    final players = game.players;

    Widget portraitView() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: PlayerScore(player: players.first)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: FractionallySizedBox(
              widthFactor: .75,
              child: ChangeTurnButton(),
            ),
          ),
          Expanded(child: PlayerScore(player: players[1])),
        ],
      );
    }

    Widget landScapeView() {
      return Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: PlayerScore(player: players.first)),
              const SizedBox(width: 16),
              Expanded(child: PlayerScore(player: players[1])),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: .25,
              child: ChangeTurnButton(),
            ),
          ),
        ],
      );
    }

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
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: const MyAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: OrientationBuilder(
              builder: (context, orientation) {
                return orientation == Orientation.landscape
                    ? landScapeView()
                    : portraitView();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.selectScoreboard.state.game;
    final round = game.round;

    final strings = AppLocalizations.of(context);

    return AppBar(
      leading: BackButton(
        onPressed: () {
          ScoreboardPageDependencies.of(context)?.data.launchExitGameDialog(
                context,
                scoreboardBloc: context.readScoreboard,
              );
        },
      ),
      centerTitle: true,
      title: Text(strings.roundNumber(round.roundCount)),
      actions: const [
        SelectVoicesButton(),
        VolumeButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
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
            border: Border.all(
              color: theme.colorScheme.inverseSurface,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              player.playerName,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.primary,
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
                border: Border.all(color: theme.colorScheme.inverseSurface),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: FittedBox(
                child: Text(
                  score.toString(),
                  style: TextStyle(color: theme.colorScheme.primary),
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
