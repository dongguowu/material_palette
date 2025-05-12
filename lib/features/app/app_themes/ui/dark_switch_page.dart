import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dark_mode_model.dart';
import 'dark_mode_notifier.dart';

@RoutePage()
class ThemeSettingsScreen extends ConsumerWidget {
  // Use ConsumerWidget
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ref is a parameter now
    final AsyncValue<DarkModeModel> darkModeProvider =
        ref.watch(darkModeNotifierProvider);

    return Center(
      child: switch (darkModeProvider) {
        AsyncData(:final value) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${value.themeMode}'),
              ElevatedButton(
                onPressed: () {
                  ref.read(darkModeNotifierProvider.notifier).toggleDarkMode();
                },
                child: const Text('Toggle Dark Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(darkModeNotifierProvider.notifier)
                      .updateDarkMode(isDark: false);
                },
                child: const Text('Set Light Mode'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(darkModeNotifierProvider.notifier)
                      .updateDarkMode(isDark: true);
                },
                child: const Text('Set Dark Mode'),
              ),
            ],
          ),
        AsyncError(:final error, :final stackTrace) => Column(
            //Proper error Handle
            children: [
              Text('Error: $error'),
              // Optionally display the stack trace (for debugging):
              Text('Stack Trace: $stackTrace'),
              //You can add a retry button if the error is recoverable.

              ElevatedButton(
                  onPressed: () {
                    ref.invalidate(darkModeNotifierProvider);
                  },
                  child: const Text(
                      "Retry")) //Added a retry button, in case the error is recoverable
            ],
          ),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}
