import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DemoLocalization {
  DemoLocalization(this.locale);

  final Locale locale;

  static DemoLocalization of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String> _localiztion;

  Future load() async {
    String jsonvalue = await rootBundle
        .loadString('lib/Language/types/${locale.languageCode}.json');

    Map<String, dynamic> mappedjson = json.decode(jsonvalue);

    _localiztion =
        mappedjson.map((key, value) => MapEntry(key, value.toString()));
  }

  String gettranslatedvalue(String key) {
    return _localiztion[key];
  }

  static const LocalizationsDelegate<DemoLocalization> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization1 = new DemoLocalization(locale);
    await localization1.load();
    return localization1;
  }

  @override
  bool shouldReload(_DemoLocalizationsDelegate old) => false;
}
