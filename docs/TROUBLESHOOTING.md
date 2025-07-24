# Material 3 Color Explorer - Troubleshooting Guide

> **❓ Document Purpose**: Provides solutions to common issues and guidance for troubleshooting. Contains step-by-step diagnostic procedures, error message explanations, and performance optimization tips for developers and support teams.

## Table of Contents
- [Common Build & Setup Issues](#common-build--setup-issues)
- [Runtime Errors & Solutions](#runtime-errors--solutions)
- [Performance Problems](#performance-problems)
- [Color Calculation Issues](#color-calculation-issues)
- [Platform-Specific Problems](#platform-specific-problems)
- [Accessibility Validation Issues](#accessibility-validation-issues)
- [Deployment Failures](#deployment-failures)
- [Advanced Troubleshooting](#advanced-troubleshooting)

## Common Build & Setup Issues

### Issue: Build fails with `build_runner` errors
**Symptoms**:
- `Could not find a file to part of for part`
- `Conflicting outputs`
- `Missing @freezed or @riverpod annotations`

**Solution**:
1.  **Clean build cache**:
    ```bash
    flutter clean
    flutter pub get
    ```
2.  **Delete conflicting outputs**:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
3.  **Check annotations**:
    - Ensure all models have `@freezed` and part files.
    - Verify providers use `@riverpod` annotation.
    - Check for missing `part 'file.freezed.dart';` or `part 'file.g.dart';` directives.
4.  **Restart IDE**: Sometimes the analysis server needs a restart.

### Issue: Missing dependencies or `pubspec.lock` issues
**Symptoms**:
- `Could not find package...`
- `Version solving failed...`

**Solution**:
1.  **Get dependencies**:
    ```bash
    flutter pub get
    ```
2.  **Upgrade packages** (if necessary):
    ```bash
    flutter pub upgrade
    ```
3.  **Check `pubspec.yaml`**:
    - Ensure correct package versions.
    - Look for conflicting dependency constraints.
4.  **Delete `pubspec.lock`**:
    ```bash
    rm pubspec.lock
    flutter pub get
    ```

### Issue: Environment configuration not loading
**Symptoms**:
- App uses wrong API endpoints or settings.
- `FLUTTER_ENV` not recognized.

**Solution**:
1.  **Verify `.env` files**: Ensure they exist and are correctly formatted.
2.  **Check build command**:
    - For mobile, ensure `--flavor` flag is used correctly.
    - For web, verify `--dart-define` is properly set.
3.  **Confirm environment loading logic**:
    - Check `main.dart` for environment loading code.
    - Ensure `AppConfig` uses correct environment variables.

## Runtime Errors & Solutions

### Issue: "Null check operator used on a null value"
**Symptoms**:
- App crashes with `_CastError` or `NoSuchMethodError`.
- Common in Riverpod providers or when accessing state.

**Solution**:
1.  **Check provider state**:
    - Is the provider in a loading or error state?
    - Use `ref.watch(provider).when(...)` to handle all states.
2.  **Validate data models**:
    - Ensure default values are provided in Freezed models.
    - Check for nullable types where data might be absent.
3.  **Inspect asynchronous operations**:
    - Ensure `await` is used correctly on `Future`s.
    - Handle potential `null` returns from async functions.

### Issue: SharedPreferences errors
**Symptoms**:
- `Could not find instance of SharedPreferences`
- Settings not persisting across sessions.

**Solution**:
1.  **Ensure `SharedPreferences.getInstance()` is awaited**:
    ```dart
    // In main.dart or service locator setup
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPreferences.getInstance(); 
    ```
2.  **Check dependency injection**:
    - Verify `SharedPreferences` is registered in GetIt.
    - Ensure services that depend on it are correctly initialized.
3.  **Validate JSON serialization**:
    - Wrap `jsonDecode` in a `try-catch` block.
    - Ensure `fromJson` and `toJson` methods are robust.

## Performance Problems

### Issue: Slow UI or dropped frames (jank)
**Symptoms**:
- Animations are not smooth (not 60fps).
- UI freezes or stutters during interaction.

**Solution**:
1.  **Use Flutter DevTools Performance view**:
    - Identify expensive `build()` methods.
    - Check for high rasterization times.
2.  **Optimize widget rebuilds**:
    - Use `const` widgets where possible.
    - Split large widgets into smaller, more focused ones.
    - Use `ref.watch` selectively on parts of a provider's state.
3.  **Move expensive work off UI thread**:
    - Use `compute()` for heavy calculations.
    - Perform file I/O or network requests asynchronously.

### Issue: High memory usage
**Symptoms**:
- App crashes on low-memory devices.
- Performance degrades over time.

**Solution**:
1.  **Use Flutter DevTools Memory view**:
    - Look for memory leaks.
    - Analyze object allocation patterns.
2.  **Properly dispose resources**:
    - Dispose of `StreamController`, `TextEditingController`, etc.
    - Ensure Riverpod providers are auto-disposed where appropriate.
3.  **Optimize images and assets**:
    - Use compressed image formats.
    - Specify cache dimensions for large images.

## Color Calculation Issues

### Issue: Incorrect color palette generated
**Symptoms**:
- Generated colors don't match Material 3 specifications.
- Seed color doesn't produce expected primary color.

**Solution**:
1.  **Verify HCT color calculations**:
    - Check against official Material 3 color utilities.
    - Ensure correct tone values are used for light/dark themes.
2.  **Debug reverse calculation algorithm**:
    - Check the color distance metric (e.g., CIEDE2000).
    - Increase search space or iterations for better accuracy.
3.  **Check for floating point inaccuracies**:
    - Use `double` for all HCT calculations.
    - Round final color values carefully.

### Issue: Color calculations are slow
**Symptoms**:
- Noticeable delay when changing seed color.
- Performance benchmarks fail for color generation.

**Solution**:
1.  **Implement caching**:
    - Cache generated palettes for recently used seed colors.
2.  **Optimize algorithms**:
    - Reduce search space for reverse seed calculation.
    - Use a more efficient color distance algorithm.
3.  **Offload to isolate**:
    - Run complex calculations in a separate isolate using `compute()`.

## Platform-Specific Problems

### Issue: iOS deployment fails
**Symptoms**:
- Code signing errors in Xcode or CI/CD.
- "Module not found" or linking errors.

**Solution**:
1.  **Check code signing**:
    - Ensure correct certificates and provisioning profiles are installed.
    - Verify bundle identifier matches profile.
2.  **Update CocoaPods**:
    ```bash
    cd ios
    pod deintegrate
    pod install
    ```
3.  **Clean Xcode build folder**:
    - In Xcode, go to Product > Clean Build Folder.

### Issue: Web app has rendering issues or is slow
**Symptoms**:
- "CanvasKit not found" errors.
- Slow initial load time.
- UI elements look different than on mobile.

**Solution**:
1.  **Choose the right web renderer**:
    - `canvaskit` for best fidelity, `html` for smaller bundle size.
    - Switch with `flutter build web --web-renderer canvaskit`.
2.  **Optimize for web**:
    - Reduce initial bundle size with code splitting.
    - Defer loading of non-critical assets.
3.  **Check for web-specific code**:
    - Use `if (kIsWeb)` for conditional platform logic.

## Accessibility Validation Issues

### Issue: Incorrect contrast ratio calculated
**Symptoms**:
- WCAG compliance levels are wrong.
- Contrast doesn't match other tools.

**Solution**:
1.  **Verify luminance calculation**:
    - Ensure correct sRGB gamma correction formula is used.
    - Check relative luminance constants (0.2126, 0.7152, 0.0722).
2.  **Check contrast formula**:
    - `(L1 + 0.05) / (L2 + 0.05)`, where L1 is lighter color.
3.  **Compare with trusted sources**:
    - Use a known-good contrast checker to validate your implementation.

## Deployment Failures

### Issue: GitHub Actions workflow fails
**Symptoms**:
- Build or test jobs fail in CI/CD pipeline.
- Deployment step times out or errors out.

**Solution**:
1.  **Check workflow logs**:
    - Identify the specific step that failed.
    - Look for detailed error messages.
2.  **Validate secrets**:
    - Ensure all required secrets (e.g., `ANDROID_KEYSTORE`, `FIREBASE_TOKEN`) are set correctly in GitHub.
3.  **Run locally**:
    - Try to replicate the failed step on your local machine.

### Issue: App rejected by App Store or Play Store
**Symptoms**:
- Rejection email with specific policy violations.

**Solution**:
1.  **Read the rejection reason carefully**:
    - Identify the exact policy violated.
2.  **Check platform guidelines**:
    - Review Apple's Human Interface Guidelines or Android's Material Design Guidelines.
3.  **Address the issue**:
    - Common reasons: missing privacy policy, improper permission usage, crashes.
    - Fix the issue, bump the version, and resubmit.

## Advanced Troubleshooting

### Using Flutter DevTools
1.  **Connect to your app**:
    - Run your app and open DevTools in your browser.
2.  **Performance Profiling**:
    - Use the Performance and CPU Profiler views to find bottlenecks.
3.  **Widget Inspector**:
    - Debug layout issues and inspect widget properties.
4.  **Network Inspector**:
    - Monitor API calls and network traffic.
5.  **Logging**:
    - View structured logs from your app.

### Debugging State Management
1.  **Use Riverpod DevTools**:
    - Add `riverpod_devtools` package.
    - Observe provider state changes in real time.
2.  **Log state changes**:
    ```dart
    class RiverpodObserver extends ProviderObserver {
      @override
      void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
        print('Provider updated: ${provider.name ?? provider.runtimeType}');
      }
    }
    // Add to ProviderScope: observers: [RiverpodObserver()]
    ```

### Reporting an Issue
If you can't solve the issue, create a bug report with:
- **App version** and **Flutter version**.
- **Steps to reproduce** the issue.
- **Expected behavior** and **actual behavior**.
- **Logs** and **screenshots**.
- **Device information** (OS, version, model).

This guide should help resolve the most common issues. For more specific problems, refer to the detailed documentation for each feature.