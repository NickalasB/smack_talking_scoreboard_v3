// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/change_turn_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/volume_button.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScoreboardBloc(TtsImplementation(FlutterTts())),
      child: const ScoreboardView(),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  const ScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final round = context.selectScoreboard.state.game.round;
    final strings = AppLocalizations.of(context);
    final roundWinnerText = round.roundWinner != null
        ? strings.playerNumber(round.roundWinner!.playerId)
        : '';
    return Scaffold(
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
              const Expanded(child: PlayerScore(playerId: 1)),
              const SizedBox(height: 16),
              const Expanded(child: PlayerScore(playerId: 2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: BlocProvider<ScoreboardBloc>.value(
                      value: context.readScoreboard,
                      child: Builder(
                        builder: (_) {
                          return SettingsButton(
                            context.readScoreboard,
                          );
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: ChangeTurnButton(
                      onTap: () {
                        context.addScoreboardEvent(NextTurnEvent());
                      },
                    ),
                  ),
                  const Flexible(child: VolumeButton()),
                ],
              ),
            ],
          ),
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
    final strings = context.l10n;
    final score = context
            .select((ScoreboardBloc bloc) => bloc.state.game)
            .players
            .firstWhereOrNull((p) => p.playerId == playerId)
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
              strings.playerNumber(playerId),
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
            onLongPress: () async => _launchResetGameDialog(context),
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
    );
  }

  Future<void> _launchResetGameDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.selectScoreboard,
          child: const _ResetGameDialog(),
        );
      },
    );
  }
}

class _ResetGameDialog extends StatelessWidget {
  const _ResetGameDialog() : super(key: const Key('reset_score_dialog'));

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      title: Center(
        child: Text(
          strings.resetGame,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32),
        ),
      ),
      content: const SizedBox(height: 24),
      actions: [
        PrimaryButton(
          onPressed: () {
            context.addScoreboardEvent(ResetGameEvent());
            Navigator.of(context).pop();
          },
          label: strings.yes,
        ),
        PrimaryButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: strings.no,
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.only(bottom: 16),
    );
  }
}
