import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/home/view/start_game_form.dart';
import 'package:smack_talking_scoreboard_v3/l10n/default_insult_l10n_retriever.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_dialogs.dart';
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
    context.addAppEvent(
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
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          appBar: AppBar(
            title: Text(strings.appTitle),
            actions: const [
              AppPopupMenuButton(key: Key('menu_button')),
            ],
          ),
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

class AppPopupMenuButton extends StatelessWidget {
  const AppPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: strings.addInsults,
            child: Text(strings.addInsults),
            onTap: () async {
              _showSettingsBottomSheet(
                context,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => InsultCreatorBloc(),
                    ),
                    BlocProvider.value(value: context.readApp),
                  ],
                  child: const AddInsultsBottomSheet(),
                ),
              );
            },
          ),
          const PopupMenuDivider(height: 8),
          PopupMenuItem<String>(
            value: strings.manageInsults,
            child: Text(strings.manageInsults),
            onTap: () async => _showSettingsBottomSheet(
              context,
              child: BlocProvider.value(
                value: context.readApp,
                child: const ManageInsultsBottomSheet(),
              ),
            ),
          )
        ];
      },
    );
  }
}

void _showSettingsBottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) {
      showModalBottomSheet<void>(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );
    },
  );
}
