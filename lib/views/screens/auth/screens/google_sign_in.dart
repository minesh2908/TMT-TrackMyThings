import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/constants/auth_slider_data.dart';
import 'package:warranty_tracker/gen/assets.gen.dart';
import 'package:warranty_tracker/views/components/body_widget.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({super.key});

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

ValueNotifier<int> count = ValueNotifier<int>(0);

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        //print(state.runtimeType);
        if (state.runtimeType == AuthSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return BodyWidget(
          isLoading: state.runtimeType == AuthLoadingState,
          child: SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: ValueListenableBuilder<int>(
                      valueListenable: count,
                      builder: (context, value, _) {
                        return PageView.builder(
                          onPageChanged: (int index) {
                            count.value = index;
                            // print(count.value);
                          },
                          itemCount: sliderData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    sliderData[index].image,
                                    height: 400,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Text(
                                    sliderData[index].title,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.scrim,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    sliderData[index].body,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.scrim,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ValueListenableBuilder<int>(
                      valueListenable: count,
                      builder: (context, value, _) {
                        return BuildDot(
                          index: value,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            context.read<AuthBloc>().add(GoogleSignInEvent());
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.svg.google.svg(height: 25),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.googleSignIn,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.bySiginigIn,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildDot extends StatelessWidget {
  const BuildDot({required this.index, super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          sliderData.length,
          (index) => Container(
            height: 10,
            width: this.index == index ? 20 : 10,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
