import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
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
        localizedDefaultInsults(ctx, insultListLength: 22),
        [
          r"$LOW$. Are your eyes even open while you're playing?",
          r'My favorite book; How not to play this game. By $LOW$',
          r"A little practice probably wouldn't kill you $LOW$.",
          r'Swipe up to increase the score. Swipe left on $LOW$, because nobody wants to date a loser.',
          r"Don't give up $LOW$. Wait let me double check the score. Oh no you should just give up actually.",
          r"I'm having deja vu. Oh wait, it's just $LOW$ still being terrible.",
          r'Hey look everybody... $LOW$ has literally just stopped trying',
          r"This is why the machines are gonna take over $LOW$. Because you can't make it happen here.",
          r'News flash. $LOW$ You suck',
          r'$LOW$, you should quit your dayjob and dedicate your life to being less terrible',
          r'Bad job $LOW$',
          r'That was the saddest thing I have ever seen $LOW$',
          r'Are you embarrassed $LOW$? You should be',
          r"This game isn't for everyone. Cough, cough $LOW$",
          r'$LOW$, congratulations on your nomination into the hall of losers',
          r'Everyone in this room is now dumber after watching $LOW$',
          r'We should rename this game to: $LOW$ sucks at life',
          r"Those who can. Do. Those who can't. Are named $LOW$",
          r'Things to add to your bucket list $LOW$. Doing much much better at this game.',
          r'$LOW$.How bad you are doing at this game is a crime in some countries',
          r"Words escape me $LOW$. Oh wait. No they don't. You are garbage.",
          r'It is physically painful to watch you play this game $LOW$',
          r'$LOW$ this reminds me of the time you invested your life savings into laserdisc stock',
        ],
      );
    }),
  );
}
