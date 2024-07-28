import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:track_my_things/constants/urls.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/theme/cubit/theme_cubit.dart';
import 'package:track_my_things/util/rating.dart';
import 'package:track_my_things/views/components/body_widget.dart';
import 'package:track_my_things/views/screens/auth/bloc/auth_bloc.dart';
import 'package:track_my_things/views/screens/language/cubit/select_language_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  bool dark = AppPrefHelper.getDarkTheme();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          SharedPrefrence().deleteUserNameSF();
          SharedPrefrence().deleteLoggedIn();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return BodyWidget(
          isLoading: state is AuthLoadingState,
          child: SafeArea(
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.settings,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/images/tmt_logo.png',
                              height: 30,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.account,
                        icon: Icons.person,
                        function: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.accountDetails,
                          );
                        },
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.language,
                        icon: Icons.language,
                        function: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.selectLanguage,
                          );
                        },
                      ),
                      SideNavBarItem(
                        function: () {
                          Navigator.pushNamed(context, RoutesName.settings);
                        },
                        title: AppLocalizations.of(context)!.generalSetting,
                        icon: Icons.settings,
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.darkTheme,
                        icon: Icons.dark_mode,
                        widget: Switch(
                          value: dark,
                          onChanged: (bool value) async {
                            setState(() {
                              dark = value;
                            });
                            final themeCubit = context.read<ThemeCubit>();
                            await AppPrefHelper.setDarkTheme(darkTheme: value);
                            // print(AppPrefHelper.getDarkTheme());
                            await themeCubit.changeTheme(value);
                          },
                        ),
                      ),
                      SideNavBarItem(
                          title: AppLocalizations.of(context)!.rateApp,
                          icon: Icons.star,
                          function: () async {
                            await showRating.launchRatingBar(context);
                          }),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.privacyPolicy,
                        icon: Icons.privacy_tip,
                        function: () {
                          launchUrl(privacyPolicy);
                        },
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.termsCondition,
                        icon: Icons.gavel,
                        function: () {
                          launchUrl(termsCondition);
                        },
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.aboutUs,
                        icon: Icons.code,
                        function: () {
                          Navigator.pushNamed(context, RoutesName.aboutMe);
                        },
                      ),
                      SideNavBarItem(
                        title: AppLocalizations.of(context)!.logOut,
                        icon: Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                        widget: const SizedBox(),
                        function: () async {
                          final selectLanguageCubit =
                              context.read<SelectLanguageCubit>();
                          final themeCubit = context.read<ThemeCubit>();
                          final authBloc = context.read<AuthBloc>();

                          await selectLanguageCubit.updateAppLanguage('en');
                          await themeCubit.changeTheme(false);
                          authBloc.add(GoogleSignOutEvent());

                          if (mounted) {
                            // Check if the widget is still mounted
                            final state = authBloc.state;
                            if (state is AuthSuccessState) {
                              await AppPrefHelper.signOut();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SideNavBarItem extends StatelessWidget {
  const SideNavBarItem({
    required this.title,
    required this.icon,
    super.key,
    this.function,
    this.widget,
    this.color,
  });
  final String title;
  final IconData icon;
  final void Function()? function;
  final Widget? widget;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: color ?? Theme.of(context).colorScheme.onSecondaryFixedVariant,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        trailing: widget ??
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
            ),
      ),
    );
  }
}
