import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/views/components/body_widget.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

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
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    sideNavBarItem(
                      title: AppLocalizations.of(context)!.account,
                      icon: Icons.person,
                      function: () {
                        Navigator.pushNamed(context, '/account-details');
                      },
                    ),
                    sideNavBarItem(
                      title: AppLocalizations.of(context)!.language,
                      icon: Icons.language,
                      function: () {
                        Navigator.pushNamed(context, '/select-language');
                      },
                    ),
                    sideNavBarItem(
                      function: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      title: AppLocalizations.of(context)!.generalSetting,
                      icon: Icons.settings,
                    ),
                    sideNavBarItem(
                      title: AppLocalizations.of(context)!.rateApp,
                      icon: Icons.star,
                    ),
                    sideNavBarItem(
                      title: AppLocalizations.of(context)!.darkTheme,
                      icon: Icons.dark_mode,
                      widget: Switch(value: false, onChanged: (value) {}),
                    ),
                    sideNavBarItem(
                      title: AppLocalizations.of(context)!.logOut,
                      icon: Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                      widget: const SizedBox(),
                      function: () async {
                        context.read<AuthBloc>().add(GoogleSignOutEvent());
                        if (state.runtimeType == AuthSuccessState) {
                          await AppPrefHelper.signOut();
                        }
                        print(
                          '-----------------------${AppPrefHelper.getDisplayName()} ${AppPrefHelper.getEmail()}${AppPrefHelper.getUID()} ${AppPrefHelper.getPhoneNumber()}',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class sideNavBarItem extends StatelessWidget {
  const sideNavBarItem({
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
        contentPadding: const EdgeInsets.all(0),
        leading: Icon(
          icon,
          color: color,
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
        trailing: widget ?? const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
