// ignore_for_file:use_key_in_widget_constructors

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/home/view/dismissible_insult_list.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

const defaultHiLowText = 'HI/LOW';
const defaultHiText = 'HI';
const defaultLowText = 'LOW';

class AddInsultsBottomSheet extends StatelessWidget {
  const AddInsultsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final offSetFromScreenBottom = MediaQuery.of(context).viewInsets.bottom;
    print('Nick $offSetFromScreenBottom');
    return Padding(
      padding: EdgeInsets.only(
        bottom: offSetFromScreenBottom,
      ),
      child: FractionallySizedBox(
        heightFactor: offSetFromScreenBottom != 0 ? .90 : .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BottomSheetHeader(
              title: context.l10n.addYourOwnSmackTalk,
              key: const Key('add_insults_bottom_sheet'),
            ),
            const Expanded(
              child: AddInsultsContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageInsultsBottomSheet extends StatelessWidget {
  const ManageInsultsBottomSheet({super.key});

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
          children: [
            BottomSheetHeader(
              title: context.l10n.savedInsults,
              key: const Key('mange_insults_bottom_sheet'),
            ),
            const Expanded(
              child: DismissibleInsultList(),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class AddInsultsContent extends StatefulWidget {
  const AddInsultsContent({
    super.key,
  });

  @override
  State<AddInsultsContent> createState() => _AddInsultsContentState();
}

class _AddInsultsContentState extends State<AddInsultsContent> {
  final Set<PlayerPlusTextInput> inputAndPlayerList = {};
  final initialInsultTextController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inputAndPlayerList.add(
      PlayerPlusTextInput(
        initialInsultTextController,
        initialHintText: context.l10n.initialInsultHint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBloc = context.readApp;
    final l10 = context.l10n;

    return Builder(
      builder: (context) {
        final insultCreatorBloc = context.selectInsultCreator;
        final constructedInsult = insultCreatorBloc.state.constructedInsult;
        final scoreboardBloc = context.readScoreboard;

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
                    children: inputAndPlayerList.mapIndexed<Widget>((i, w) {
                      if (i + 1 > 1 && i + 1 == inputAndPlayerList.length) {
                        return Stack(
                          children: [
                            w,
                            Positioned(
                              right: 1,
                              top: 1,
                              child: SizedOverflowBox(
                                size: const Size(24, 24),
                                child: IconButton(
                                  key: const Key('insult_undo_button'),
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                  ),
                                  onPressed: () {
                                    insultCreatorBloc.add(
                                      CreateInsultEvent(
                                        '',
                                        index: inputAndPlayerList.length - 1,
                                      ),
                                    );
                                    inputAndPlayerList
                                        .remove(inputAndPlayerList.last);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return w;
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const DraggableHiLowScore(
                      draggableKey: Key('hi_draggable'),
                      label: defaultHiText,
                      isHighScorer: true,
                    ),
                    PrimaryButton.outlined(
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
                      label: l10.addToInsult,
                    ),
                    const DraggableHiLowScore(
                      draggableKey: Key('low_draggable'),
                      label: defaultLowText,
                      isHighScorer: false,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PrimaryButton.filled(
                    key: const Key('save_button'),
                    onPressed: isValidInsult
                        ? () {
                            appBloc.add(SaveInsultEvent(constructedInsult));
                            Navigator.of(context).pop();
                          }
                        : null,
                    label: l10.save,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PrimaryButton.outlined(
                    key: const Key('listen_button'),
                    onPressed: isValidInsult
                        ? () {
                            scoreboardBloc.add(
                              SpeakInsultEvent(constructedInsult.trim()),
                            );
                          }
                        : null,
                    label: l10.listen,
                  ),
                ),
              ],
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
    this.initialHintText,
    super.key,
  });

  final TextEditingController controller;
  final int index;
  final String? initialHintText;

  @override
  State<PlayerPlusTextInput> createState() => _PlayerPlusTextInputState();
}

class _PlayerPlusTextInputState extends State<PlayerPlusTextInput> {
  String draggedText = defaultHiLowText;
  late String fullInsultInfo;
  final focusNode = FocusNode()..requestFocus();
  bool canAcceptDraggable = false;

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
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        DragTarget<String>(
          key: Key('hi_low_drag_target_${widget.index}'),
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Align(
              alignment: Alignment.centerLeft,
              widthFactor: 1,
              child: canAcceptDraggable
                  ? PrimaryButton.filled(
                      label: draggedText,
                      minWidth: 64,
                      onPressed: () {}, // coverage:ignore-line
                    )
                  : PrimaryButton.outlined(
                      label: draggedText,
                      minWidth: 64,
                    ),
            );
          },
          onWillAccept: (data) {
            HapticFeedback.heavyImpact();
            canAcceptDraggable = true;
            draggedText = data!;
            return true;
          },
          onLeave: (data) {
            canAcceptDraggable = false;
            draggedText = defaultHiLowText;
          },
          onAccept: (String data) {
            draggedText = data;
            createInsultEvent();
          },
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
                decoration: InputDecoration(
                  hintText: widget.initialHintText,
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
    required this.isHighScorer,
  });

  final String label;
  final Key draggableKey;
  final bool isHighScorer;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return Draggable<String>(
      key: draggableKey,
      data: label,
      feedbackOffset: const Offset(0, -50),
      dragAnchorStrategy: (_, __, ___) => const Offset(25, 75),
      feedback: Opacity(
        opacity: 0.5,
        child: Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: Material(
            color: Colors.transparent,
            child: Transform.rotate(
              angle: isHighScorer ? .20 : -.20,
              child: HiLoWidget(label: label),
            ),
          ),
        ),
      ),
      childWhenDragging: PrimaryButton.outlined(
        label: label,
        minWidth: 64,
        onPressed: () {}, // coverage:ignore-line
      ),
      child: Material(
        child: Tooltip(
          message: isHighScorer
              ? strings.draggableToolTipHi
              : strings.draggableToolTipLow,
          preferBelow: false,
          verticalOffset: 40,
          textAlign: TextAlign.center,
          margin: isHighScorer
              ? const EdgeInsets.only(right: 120)
              : const EdgeInsets.only(left: 120),
          showDuration: const Duration(seconds: 3),
          excludeFromSemantics: true,
          triggerMode: TooltipTriggerMode.tap,
          child: HiLoWidget(label: label),
        ),
      ),
    );
  }
}

class HiLoWidget extends StatelessWidget {
  const HiLoWidget({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(
        minWidth: 64,
        minHeight: kMinInteractiveDimension,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.buttonTheme.colorScheme?.primary,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
