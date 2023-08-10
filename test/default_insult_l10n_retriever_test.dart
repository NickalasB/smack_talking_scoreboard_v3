import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/home/home.dart';
import 'package:smack_talking_scoreboard_v3/l10n/default_insult_l10n_retriever.dart';

import 'harness.dart';

void main() {
  testWidgets(
    'Should properly map  localized insults',
    appHarness((given, when, then) async {
      final globalKey = GlobalKey();
      late BuildContext ctx;

      await given.pumpWidget(
        Builder(
          builder: (context) {
            ctx = context;
            return Placeholder(key: globalKey);
          },
        ),
      );

      expect(
        localizedDefaultInsults(ctx,
            maxDefaultInsultIndex: maxDefaultInsultIndex),
        [
          "##LOW##. Are your eyes even open while you're playing?",
          'My favorite book; How not to play this game. By ##LOW##',
          "A little practice probably wouldn't kill you ##LOW##.",
          'Swipe up to increase the score. Swipe left on ##LOW##, because nobody wants to date a loser.',
          "Don't give up ##LOW##. Wait let me double check the score. Oh no you should just give up actually.",
          "I'm having deja vu. Oh wait, it's just ##LOW## still being terrible.",
          'Hey look everybody... ##LOW## has literally just stopped trying',
          "This is why the machines are gonna take over ##LOW##. Because you can't make it happen here.",
          'News flash. ##LOW## You suck',
          '##LOW##, you should quit your dayjob and dedicate your life to being less terrible',
          'Bad job ##LOW##',
          'That was the saddest thing I have ever seen ##LOW##',
          'Are you embarrassed ##LOW##? You should be',
          "This game isn't for everyone. Cough, cough ##LOW##",
          '##LOW##, congratulations on your nomination into the hall of losers',
          'Everyone in this room is now dumber after watching ##LOW##',
          'We should rename this game to: ##LOW## sucks at life',
          "Those who can. Do. Those who can't. Are named ##LOW##",
          'Things to add to your bucket list ##LOW##. Doing much much better at this game.',
          '##LOW##.How bad you are doing at this game is a crime in some countries',
          "Words escape me ##LOW##. Oh wait. No they don't. You are garbage.",
          'It is physically painful to watch you play this game ##LOW##',
          '##LOW## this reminds me of the time you invested your life savings into laserdisc stock',
        ],
      );

      expect(
        localizedDefaultTieInsults(ctx,
            maxDefaultTieInsultIndex: maxDefaultTieInsultIndex),
        [
          "Oh wow- a tie! Cuz that's fun?",
          "At least you two won't be lonely in sucks-ville",
          "I'm just gonna say it. You both suck equally",
          'Tie games are like plain yogurt. Lame.',
          'Cool. Looks like nobody showed up to play today',
          'This is more boring than a draw at an arm wrestling contest.',
          'What if we actually tried to score? I think that would be more fun for everyone.',
          'Maybe go back and read the instructions on how to actually score in this game?',
          "I can't tell. Is anyone actually trying here?",
          'Dear diary. Today I witnessed a game so uneventful, I just wanted to lay down and cry',
          "Don't bother scoring. Everyone is totally entertained by absolutely nothing happening!",
        ],
      );
    }),
  );
}
