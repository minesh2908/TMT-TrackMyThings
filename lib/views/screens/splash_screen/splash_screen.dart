import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Text(
          'Warranty Tracker',
          style: TextStyle(fontSize: 36, color: Colors.white),
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
