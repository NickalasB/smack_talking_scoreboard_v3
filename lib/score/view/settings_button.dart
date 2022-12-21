import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/settings_dialogs.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton(
    this.bloc, {
    super.key,
  });
  final AppBloc bloc;

  @override
  Widget build(BuildContext context) {
    return CircularButton(
      key: const Key('settings_button'),
      onTap: () {
        showModalBottomSheet<String?>(
          context: context,
          isScrollControlled: true,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bloc),
              BlocProvider<InsultCreatorBloc>(
                create: (context) => InsultCreatorBloc(),
              )
            ],
            child: const AddInsultsDialog(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      child: const Icon(Icons.settings),
    );
  }
}
