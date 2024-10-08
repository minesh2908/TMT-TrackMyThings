import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:track_my_things/constants/api_key.dart';
import 'package:track_my_things/firebase_options.dart';
import 'package:track_my_things/notifications/notification_service.dart';
import 'package:track_my_things/routes/routes.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/theme/color_sceme.dart';
import 'package:track_my_things/theme/cubit/theme_cubit.dart';
import 'package:track_my_things/theme/theme_manager.dart';
import 'package:track_my_things/views/screens/add_product/bloc/product_bloc.dart';
import 'package:track_my_things/views/screens/auth/bloc/auth_bloc.dart';
import 'package:track_my_things/views/screens/fetch_image_data/bloc/fetch_image_data_bloc.dart';
import 'package:track_my_things/views/screens/language/cubit/select_language_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initializing firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPref.init();

  //Initializing Gemini
  Gemini.init(apiKey: geminiApiKey);

  runApp(const MyApp());
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  await NotificationService.localNotification();

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
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
              ProductBloc()..add(GetAllProductEvent(filterValue: '1')),
        ),
        BlocProvider<SelectLanguageCubit>.value(
          value: SelectLanguageCubit(),
        ),
        BlocProvider<ThemeCubit>.value(
          value: ThemeCubit(),
        ),
        BlocProvider(create: (context) => FetchImageDataBloc()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, themeSate) {
          return BlocBuilder<SelectLanguageCubit, String>(
            builder: (context, state) {
              return MaterialApp(
                title: 'TMT : Track My Things',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode: themeSate ? ThemeMode.dark : ThemeMode.light,
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
          );
        },
      ),
    );
  }
}
