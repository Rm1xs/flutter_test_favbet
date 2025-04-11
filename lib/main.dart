import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/theme_notifier.dart';
import 'core/routing/routes.dart';
import 'core/theme/app_theme.dart';
import 'features/favorites/presentation/providers/favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return FutureBuilder(
      future: ref.read(themeProvider.notifier).loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        final isDarkTheme = ref.watch(themeProvider);
        return MaterialApp.router(
          routerConfig: router,
          title: 'Movies App',
          theme: isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
