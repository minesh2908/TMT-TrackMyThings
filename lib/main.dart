import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:warranty_tracker/firebase_options.dart';
import 'package:warranty_tracker/routes/routes.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/theme/color_sceme.dart';
import 'package:warranty_tracker/theme/theme_manager.dart';
import 'package:warranty_tracker/views/screens/Language/cubit/select_language_cubit.dart';
import 'package:warranty_tracker/views/screens/add_product/bloc/product_bloc.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc()..add(GetAllProductEvent(test: 'From Main')),
        ),
        BlocProvider<SelectLanguageCubit>.value(
          value: SelectLanguageCubit(),
        ),
      ],
      child: BlocBuilder<SelectLanguageCubit, String>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Warranty Tracker App',
            theme: appTheme(
              context,
              colorScheme: lightColorScheme,
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            darkTheme: appTheme(
              context,
              colorScheme: darkColorScheme,
              systemUiOverlayStyle: SystemUiOverlayStyle.light,
            ),
            initialRoute: RoutesName.splashScreen,
            onGenerateRoute: Routes.generateRoute,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('hi')],
            locale: Locale(state),
          );
        },
      ),
    );
  }
}
