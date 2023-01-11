// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/view/app_theme.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

extension PumpMaterialWidget on WidgetTester {
  Future<void> pumpMaterialWidget(
    Widget widget, {
    NavigatorObserver? navigatorObserver,
  }) {
    return pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        theme: AppTheme.theme(),
        darkTheme: AppTheme.theme(brightness: Brightness.dark),
        supportedLocales: AppLocalizations.supportedLocales,
        home: Material(child: widget),
        navigatorObservers:
            navigatorObserver != null ? [navigatorObserver] : [],
      ),
    );
  }
}
