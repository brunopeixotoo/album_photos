import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo/core/ui/ui.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: UiConfig.lightTheme,
      dark: UiConfig.darkTheme,
      initial: AdaptiveThemeMode.system,
      builder: (light, dark) {
        return MaterialApp.router(
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                textScaler: const TextScaler.linear(1),
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: UiConfig.title,
          theme: light,
          routerConfig: Modular.routerConfig,
          darkTheme: dark,
          localizationsDelegates: const [],
          locale: const Locale('pt', 'BR'),
        );
      },
    );
  }
}
