// ignore_for_file:use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/dismissible_insult_list.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

const defaultHiLowText = 'HI/LOW';
const defaultHiText = 'HI';
const defaultLowText = 'LOW';

class AddInsultsDialog extends StatelessWidget {
  const AddInsultsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            BottomSheetHeader(
              key: Key('settings_bottom_sheet'),
            ),
            Expanded(
              child: BottomSheetContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageInsultsDialog extends StatelessWidget {
  const ManageInsultsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            BottomSheetHeader(
              key: Key('mange_insults_bottom_sheet'),
            ),
            Expanded(
              child: DismissibleInsultList(),
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
    final bloc = context.readApp;
    final l10 = context.l10n;

    return Builder(
      builder: (context) {
        final insultCreatorBloc = context.selectInsultCreator;
        final constructedInsult = insultCreatorBloc.state.constructedInsult;

        final isValidInsult = constructedInsult.trim().isNotEmpty &&
            !constructedInsult.contains(r'$invalid');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SingleChildScrollView(
                  child: Wrap(
                    runSpacing: 4,
                    children: inputAndPlayerList.toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const DraggableHiLowScore(
                  draggableKey: Key('hi_draggable'),
                  label: defaultHiText,
                ),
                PrimaryButton(
                  key: const Key('add_more_insult_text_button'),
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
                  label: l10.add,
                ),
                const DraggableHiLowScore(
                  draggableKey: Key('low_draggable'),
                  label: defaultLowText,
                ),
              ],
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PrimaryButton(
                key: const Key('done_button'),
                onPressed: isValidInsult
                    ? () {
                        bloc.add(SaveInsultEvent(constructedInsult));
                        Navigator.of(context).pop();
                      }
                    : null,
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
  String draggedText = defaultHiLowText;
  late String fullInsultInfo;
  final focusNode = FocusNode()..requestFocus();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(createInsultEvent);
  }

  void createInsultEvent() {
    final insultCreatorBloc = context.readInsultCreator;
    final formattedDraggedText = '\$$draggedText\$';
    fullInsultInfo = '$formattedDraggedText ${widget.controller.text}';
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
              key: Key('hi_low_drag_target_${widget.index}'),
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
                      draggedText,
                      style: draggedText != defaultHiLowText
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
                key: Key('insult_text_field_${widget.index}'),
                maxLines: null,
                controller: widget.controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
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

class DraggableHiLowScore extends StatelessWidget {
  const DraggableHiLowScore({
    required this.draggableKey,
    required this.label,
  });

  final String label;
  final Key draggableKey;
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      key: draggableKey,
      data: label,
      feedback: PrimaryButton(
        onPressed: () {}, // coverage:ignore-line
        label: label,
      ),
      childWhenDragging: PrimaryButton(
        onPressed: () {}, // coverage:ignore-line
        label: label,
        isFilled: false,
      ),
      child: PrimaryButton(
        onPressed: () {}, // coverage:ignore-line
        label: label,
      ),
    );
  }
}
