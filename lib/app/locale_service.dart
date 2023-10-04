import 'dart:io';

abstract class LocaleService {
  String get platformLocaleName;
}

class AppLocaleService implements LocaleService {
  const AppLocaleService();

  @override
  String get platformLocaleName => Platform.localeName;
}
