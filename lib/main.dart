import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/core/storage_helper/app_shared_preference_helper.dart';
import 'package:fitness_app/core/storage_helper/secure_storage_helper.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness_app/core/constants/app_values.dart';
import 'package:fitness_app/core/di/service_locator.dart';
import 'package:fitness_app/core/routes/route_generator.dart';
import 'package:fitness_app/core/routes/routes.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/utils/bloc_observer.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
    apiKey: AppValues.apiKey,
  );
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  SharedPreferencesHelper.init();
  Bloc.observer = MyBlocObserver();

  final initialRoute = await getInitialRoute();

  runApp(
    EasyLocalization(
      supportedLocales: AppValues.supportedLocales,
      fallbackLocale: AppValues.englishLocale,
      path: AppValues.pathTranslation,
      child: DevicePreview(
        enabled: false,
        builder: (context) => MyApp(initialRoute: initialRoute), // Wrap your app
      ),
    ),
  );
}

Future<String> getInitialRoute() async {
  final tokenCheck = await SecureStorageHelper.instance.getSecure(key: AppValues.token);
  final isOnboardingCompleted =
      SharedPreferencesHelper.getData(key: AppValues.isOnboardingCompleted) as bool?;

  if (isOnboardingCompleted == null || !isOnboardingCompleted) return Routes.onboarding;
  return tokenCheck != null ? Routes.appSection : Routes.login;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.textScalerOf(context).scale(1.0).clamp(0.85, 1.2),
            ),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            title: AppValues.appTitle,
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: initialRoute,
          ),
        );
      },
    );
  }
}
