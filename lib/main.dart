import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    // Wrap with MultiProvider for state management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const HorizonAttendanceApp(),
    ),
  );
}

class HorizonAttendanceApp extends StatelessWidget {
  const HorizonAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp(
          title: 'Horizon Attendance',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          
          // Localization configuration
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en'), // English
            Locale('id'), // Bahasa Indonesia
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          home: const LoginScreen(),
        );
      },
    );
  }
}
