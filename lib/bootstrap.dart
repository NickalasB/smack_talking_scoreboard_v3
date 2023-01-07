// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_theme/json_theme.dart';
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
    FutureOr<Widget> Function(
            {required ThemeData lightTheme, required ThemeData darkTheme})
        builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      EquatableConfig.stringify;
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );

      final lightThemeString = await rootBundle.loadString(
        'assets/appainter_theme_material_3.json',
      );
      final lightThemeJson = jsonDecode(lightThemeString);
      final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson)!;

      final darkThemeString = await rootBundle.loadString(
        'assets/appainter_theme_dark_material_3.json',
      );
      final darkThemeJson = jsonDecode(darkThemeString);
      final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

      runApp(await builder(lightTheme: lightTheme, darkTheme: darkTheme));
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
