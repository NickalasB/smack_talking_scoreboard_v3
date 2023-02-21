import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/home/view/settings.dart';
import 'package:smack_talking_scoreboard_v3/home/view/start_game_form.dart';
import 'package:smack_talking_scoreboard_v3/l10n/default_insult_l10n_retriever.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

const _numOfScrollingInsults = 8;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  final List<ScrollController> _scrollControllers = [];
  final List<String> _items = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _numOfScrollingInsults; i++) {
      _scrollControllers.add(ScrollController());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.watch<AppBloc>().add(
          LoadDefaultInsultsEvent(
            defaultInsults: localizedDefaultInsults(
              context,
              maxDefaultInsultIndex: 22,
            ),
          ),
        );

    if (_items.isEmpty) {
      _items.addAll(context.readApp.state.insults);
    }
    _timer ??= Timer.periodic(const Duration(milliseconds: 100), (timer) {
      for (var i = 0; i < _numOfScrollingInsults; i++) {
        if (_scrollControllers[i].hasClients) {
          _scrollControllers[i].animateTo(
            i.isEven
                ? _scrollControllers[i].offset + 5
                : _scrollControllers[i].offset + 10,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
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
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: const [
              AppPopupMenuButton(key: Key('menu_button')),
            ],
          ),
          body: Stack(
            children: [
              if (_scrollControllers.isNotEmpty && _items.isNotEmpty)
                Column(
                  children:
                      _scrollControllers.mapIndexed<Widget>((i, controller) {
                    return Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Text(
                            '${_items[Random().nextInt(_items.length)]} ',
                            style: Theme.of(context).textTheme.headlineLarge,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              Center(
                child: PrimaryButton.filled(
                  key: const Key('get_started_button'),
                  label: strings.getStarted,
                  textStyle: Theme.of(context).textTheme.headlineSmall,
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
            ],
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
                    BlocProvider.value(value: context.readScoreboard),
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
