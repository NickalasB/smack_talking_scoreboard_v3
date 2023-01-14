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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: PlayerScore(player: players.first)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  child: FractionallySizedBox(
                    heightFactor: .65,
                    child: SizedBox(
                      width: 48,
                      child: ChangeTurnButton(isLandscape: true),
                    ),
                  ),
                ),
                Expanded(child: PlayerScore(player: players[1])),
              ],
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
            padding: const EdgeInsets.all(16),
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

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
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
      actions: [
        IconButton(
          onPressed: () {
            context.addScoreboardEvent(ToggleInsultVolumeEvent());
          },
          isSelected: context.selectScoreboard.state.areInsultsEnabled,
          selectedIcon: const Icon(
            Icons.volume_up_outlined,
          ),
          icon: const Icon(
            Icons.volume_off_outlined,
          ),
        )
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
            border: Border.all(color: theme.colorScheme.inverseSurface),
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
