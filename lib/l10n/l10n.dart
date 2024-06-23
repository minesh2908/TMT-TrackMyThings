import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// enum AppLocale {
//   english('en'),
//   hindi('hi');

//   const AppLocale(this.code);
//   final String code;
// }

extension LocalizationStrings on BuildContext {
  AppLocalizations get lang {
    return AppLocalizations.of(this)!;
  }
}
