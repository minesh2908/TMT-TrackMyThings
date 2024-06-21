import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/views/screens/Language/cubit/select_language_cubit.dart';

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
      body: BlocBuilder<SelectLanguageCubit, String>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    const selectedLanguageIndex = 0;
                    return InkWell(
                      onTap: () {
                        if (languages[index]['name'] == 'English') {
                          context
                              .read<SelectLanguageCubit>()
                              .updateAppLanguage('en');
                        } else if (languages[index]['name'] == 'हिंदी') {
                          context
                              .read<SelectLanguageCubit>()
                              .updateAppLanguage('hi');
                        }
                      },
                      child: ListTile(
                        title: Text(
                          languages[index]['name']!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        trailing: state == languages[index]['code']
                            ? const Icon(Icons.check)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
