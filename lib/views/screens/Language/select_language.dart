import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:warranty_tracker/views/screens/Language/select_language_provider.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final languages = [
    {
      'name': 'English',
      'code': 'en',
    },
    {
      'name': 'हिंदी',
      'code': 'hi',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeNotifier>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 2,
            title: Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    const selectedLanguageIndex = 0;
                    return InkWell(
                      onTap: () {
                        if (languages[index]['name'] == 'English') {
                          provider.ChangeLanguage(
                            Locale(languages[index]['code']!),
                          );
                        } else if (languages[index]['name'] == 'हिंदी') {
                          provider.ChangeLanguage(
                            Locale(languages[index]['code']!),
                          );
                        }
                      },
                      child: ListTile(
                        title: Text(
                          languages[index]['name']!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        trailing: provider.appLang?.languageCode ==
                                languages[index]['code']
                            ? const Icon(Icons.check)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
