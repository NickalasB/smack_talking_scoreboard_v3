import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/default_insult_l10n_retriever.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.readApp.add(
      LoadDefaultInsultsEvent(
        defaultInsults: localizedDefaultInsults(
          context,
          maxDefaultInsultIndex: 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Builder(
      builder: (context) {
        return Scaffold(
          body: Center(
            child: PrimaryButton(
              key: const Key('get_started_button'),
              label: strings.getStarted,
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(16),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.pickYourPoison),
                          const Divider(thickness: 2),
                        ],
                      ),
                      content: const StartGameForm(),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class StartGameForm extends StatefulWidget {
  const StartGameForm({super.key});

  @override
  State<StartGameForm> createState() => _StartGameFormState();
}

class _StartGameFormState extends State<StartGameForm> {
  final _formKey = GlobalKey<FormState>();

  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  final winningScoreController = TextEditingController();
  final pointsPerScoreController = TextEditingController();
  final winByMarginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final strings = context.l10n;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _GameFormField(
              key: const Key('player_1_form_field'),
              player1Controller,
              hintText: strings.player1Hint,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 8),
            _GameFormField(
              key: const Key('player_2_form_field'),
              player2Controller,
              hintText: strings.player2Hint,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 8),
            _GameFormField(
              key: const Key('winning_score_form_field'),
              winningScoreController,
              hintText: strings.winningScoreHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            _GameFormField(
              key: const Key('points_per_score_form_field'),
              pointsPerScoreController,
              hintText: strings.pointsPerScoreHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            _GameFormField(
              key: const Key('win_by_margin_form_field'),
              winByMarginController,
              hintText: strings.winByMarginHint,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              key: const Key('lets_go_button'),
              label: strings.letsGo,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.addScoreboardEvent(
                    StartGameEvent(
                      player1: Player(
                        playerId: 1,
                        playerName: player1Controller.text,
                      ),
                      player2: Player(
                        playerId: 2,
                        playerName: player2Controller.text,
                      ),
                      gamePointParams: GamePointParams(
                        winningScore: int.parse(winningScoreController.text),
                        pointsPerScore:
                            int.parse(pointsPerScoreController.text),
                        winByMargin: int.parse(winByMarginController.text),
                      ),
                    ),
                  );
                  navigator
                    ..pop()
                    ..push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          return const ScoreboardPage();
                        },
                      ),
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player1Controller.dispose();
    player2Controller.dispose();
    winningScoreController.dispose();
    pointsPerScoreController.dispose();
    winByMarginController.dispose();
    super.dispose();
  }
}

class _GameFormField extends StatelessWidget {
  const _GameFormField(
    this.controller, {
    super.key,
    required this.hintText,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return strings.defaultFormError;
        }
        return null;
      },
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
