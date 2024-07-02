import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/views/screens/auth/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    isUserAuthenticated(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tmt_logo.png',
              height: 150,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'TRACK MY THINGS',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF727376),
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'TMT',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF58634),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> isUserAuthenticated(BuildContext context) async {
  final firebaseAuth = FirebaseAuth.instance;
  final isUserAvailable = firebaseAuth.currentUser;

  if (isUserAvailable != null) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      context.read<AuthBloc>().add(GetCurrentUserData());
      //Navigator.pushNamed(context, '/dashboard');
      Navigator.pushReplacementNamed(context, RoutesName.dashboard);
    });
  } else {
    Future.delayed(const Duration(milliseconds: 1500), () {
      //Navigator.pushNamed(context, '/');
      Navigator.pushReplacementNamed(context, RoutesName.authScreen);
    });
  }
}
