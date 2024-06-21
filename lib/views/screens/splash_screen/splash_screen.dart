import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
    isUserAuthenticated(context);
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
      Navigator.pushNamed(context, '/dashboard');
    });
  } else {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushNamed(context, '/');
    });
  }
}
