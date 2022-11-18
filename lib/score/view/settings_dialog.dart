import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/dismissible_insult_list.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            BottomSheetHeader(
              key: Key('settings_bottom_sheet'),
            ),
            Flexible(
              child: BottomSheetContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.addYourOwnSmackTalk,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    super.key,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final Set<PlayerPlusTextInput> inputAndPlayerList = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    inputAndPlayerList.add(PlayerPlusTextInput(TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.readScoreboard;
    final l10 = context.l10n;

    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Wrap(
                  runSpacing: 4,
                  children: inputAndPlayerList.toList(),
                ),
              ),
            ),
            const Divider(thickness: 2),
            const Expanded(
              child: DismissibleInsultList(),
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Draggable<String>(
                  data: 'Hi',
                  feedback: PrimaryButton(onPressed: () {}, label: 'Hi'),
                  childWhenDragging: PrimaryButton(
                    onPressed: () {},
                    label: 'Hi',
                    isFilled: false,
                  ),
                  child: PrimaryButton(onPressed: () {}, label: 'Hi'),
                ),
                PrimaryButton(
                  onPressed: () {
                    setState(() {
                      inputAndPlayerList.add(
                        PlayerPlusTextInput(
                          TextEditingController(),
                          index: inputAndPlayerList.length,
                        ),
                      );
                    });
                  },
                  label: 'Add',
                ),
                Draggable<String>(
                  data: 'Low',
                  feedback: PrimaryButton(onPressed: () {}, label: 'Low'),
                  childWhenDragging: PrimaryButton(
                    onPressed: () {},
                    label: 'Low',
                    isFilled: false,
                  ),
                  child: PrimaryButton(onPressed: () {}, label: 'Low'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PrimaryButton(
                onPressed: () {
                  final insultCreatorBloc =
                      BlocProvider.of<InsultCreatorBloc>(context);

                  bloc.add(
                    SaveInsultEvent(
                      insultCreatorBloc.state.constructedInsult,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                label: l10.done,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PlayerPlusTextInput extends StatefulWidget {
  const PlayerPlusTextInput(
    this.controller, {
    this.index = 0,
    super.key,
  });

  final TextEditingController controller;
  final int index;

  @override
  State<PlayerPlusTextInput> createState() => _PlayerPlusTextInputState();
}

class _PlayerPlusTextInputState extends State<PlayerPlusTextInput> {
  String? draggedText;
  late String fullInsultInfo;
  final focusNode = FocusNode()..requestFocus();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(createInsultEvent);
  }

  void createInsultEvent() {
    final insultCreatorBloc = BlocProvider.of<InsultCreatorBloc>(context);
    fullInsultInfo = '$draggedText ${widget.controller.text}';
    insultCreatorBloc.add(
      CreateInsultEvent(
        fullInsultInfo,
        index: widget.index,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(createInsultEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.disabledColor),
          ),
          child: SizedBox(
            height: kTextTabBarHeight,
            width: kTextTabBarHeight,
            child: DragTarget<String>(
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1,
                  child: Center(
                    child: Text(
                      draggedText ?? 'Hi/Low',
                      style: draggedText != null
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.titleLarge
                              ?.copyWith(color: theme.disabledColor),
                    ),
                  ),
                );
              },
              onWillAccept: (date) {
                HapticFeedback.heavyImpact();
                return true;
              },
              onAccept: (String data) {
                draggedText = data;
                createInsultEvent();
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48),
              child: TextField(
                focusNode: focusNode,
                showCursor: true,
                key: const Key('insult_text_field'),
                maxLines: null,
                controller: widget.controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                ),
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
