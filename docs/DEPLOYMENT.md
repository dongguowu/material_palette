# Material 3 Color Explorer - Deployment Guide

> **🚀 Document Purpose**: Defines deployment procedures and CI/CD workflows. Contains build configurations, release processes, and platform-specific deployment steps for DevOps engineers and release managers.

## Table of Contents
- [Deployment Overview](#deployment-overview)
- [Environment Configuration](#environment-configuration)
- [Build Configurations](#build-configurations)
- [CI/CD Pipeline](#cicd-pipeline)
- [Platform-Specific Deployment](#platform-specific-deployment)
- [Release Management](#release-management)
- [Monitoring & Rollback](#monitoring--rollback)
- [Security & Secrets Management](#security--secrets-management)

## Deployment Overview

### Deployment Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                    Source Control                           │
│                     GitHub                                  │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                 CI/CD Pipeline                              │
│              GitHub Actions                                 │
├─────────────────────┬───────────────────────────────────────┤
│  • Code Quality     │  • Testing        │  • Building       │
│  • Linting         │  • Unit Tests     │  • Platform Builds │
│  • Security Scan   │  • Widget Tests   │  • Asset Bundling │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                Platform Deployment                          │
├─────────────────┬───────────────┬───────────────────────────┤
│     Mobile      │     Web       │        Desktop            │
│  • App Store    │  • Firebase   │     • GitHub Releases     │
│  • Play Store   │  • Netlify    │     • Package Managers    │
│  • TestFlight   │  • Vercel     │                           │
└─────────────────┴───────────────┴───────────────────────────┘
```

### Supported Deployment Targets
- **iOS**: App Store Connect, TestFlight (Beta)
- **Android**: Google Play Store, Play Console (Internal Testing)
- **Web**: Firebase Hosting, Netlify, Vercel, GitHub Pages
- **Desktop**: GitHub Releases, Package Managers (Future)

## Environment Configuration

### Environment Types
```dart
enum Environment {
  development,
  staging,
  production,
}

class DeploymentConfig {
  static const Environment currentEnv = Environment.production;
  
  static const Map<Environment, EnvConfig> configs = {
    Environment.development: EnvConfig(
      apiBaseUrl: 'http://localhost:3000',
      enableDebugFeatures: true,
      logLevel: LogLevel.debug,
    ),
    Environment.staging: EnvConfig(
      apiBaseUrl: 'https://staging-api.materialpalette.dev',
      enableDebugFeatures: true,
      logLevel: LogLevel.info,
    ),
    Environment.production: EnvConfig(
      apiBaseUrl: 'https://api.materialpalette.dev',
      enableDebugFeatures: false,
      logLevel: LogLevel.warning,
    ),
  };
}
```

### Environment Variables
```yaml
# .env.development
FLUTTER_ENV=development
API_BASE_URL=http://localhost:3000
ENABLE_DEBUG_FEATURES=true
LOG_LEVEL=debug

# .env.staging  
FLUTTER_ENV=staging
API_BASE_URL=https://staging-api.materialpalette.dev
ENABLE_DEBUG_FEATURES=true
LOG_LEVEL=info

# .env.production
FLUTTER_ENV=production
API_BASE_URL=https://api.materialpalette.dev
ENABLE_DEBUG_FEATURES=false
LOG_LEVEL=warning
```

## Build Configurations

### Flutter Build Commands
```bash
# Development builds
flutter build apk --debug --flavor development
flutter build ios --debug --flavor development
flutter build web --debug

# Staging builds
flutter build apk --release --flavor staging
flutter build ios --release --flavor staging  
flutter build web --release --dart-define=FLUTTER_ENV=staging

# Production builds
flutter build apk --release --flavor production --obfuscate --split-debug-info=build/debug-info
flutter build ios --release --flavor production --obfuscate --split-debug-info=build/debug-info
flutter build web --release --dart-define=FLUTTER_ENV=production
```

### Build Optimization Flags
```yaml
# android/app/build.gradle
android {
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            
            // Optimization flags
            shrinkResources true
            zipAlignEnabled true
            
            // Build-specific configurations
            buildConfigField "String", "BUILD_TYPE", '"release"'
            buildConfigField "boolean", "ENABLE_LOGGING", "false"
        }
    }
}
```

### Web Build Configuration
```yaml
# web/index.html optimization
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Performance optimizations -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="dns-prefetch" href="https://fonts.gstatic.com">
  
  <!-- PWA manifest -->
  <link rel="manifest" href="manifest.json">
  
  <!-- Service worker -->
  <script>
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('flutter_service_worker.js');
    }
  </script>
</head>
</html>
```

## CI/CD Pipeline

### GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Build and Deploy

on:
  push:
    branches: [main, develop]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  FLUTTER_VERSION: '3.7.2'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: dart run build_runner build --delete-conflicting-outputs
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/v')
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      
      - name: Setup Android signing
        env:
          ANDROID_KEYSTORE: ${{ secrets.ANDROID_KEYSTORE }}
          ANDROID_KEY_PROPERTIES: ${{ secrets.ANDROID_KEY_PROPERTIES }}
        run: |
          echo "$ANDROID_KEYSTORE" | base64 --decode > android/app/keystore.jks
          echo "$ANDROID_KEY_PROPERTIES" > android/key.properties
      
      - name: Build APK
        run: flutter build apk --release --flavor production
      
      - name: Build App Bundle
        run: flutter build appbundle --release --flavor production
      
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.materialpalette.app
          releaseFiles: build/app/outputs/bundle/productionRelease/app-production-release.aab
          track: internal

  build-ios:
    needs: test
    runs-on: macos-latest
    if: startsWith(github.ref, 'refs/tags/v')
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      
      - name: Setup iOS signing
        env:
          IOS_CERTIFICATE_P12: ${{ secrets.IOS_CERTIFICATE_P12 }}
          IOS_CERTIFICATE_PASSWORD: ${{ secrets.IOS_CERTIFICATE_PASSWORD }}
          IOS_PROVISIONING_PROFILE: ${{ secrets.IOS_PROVISIONING_PROFILE }}
        run: |
          echo "$IOS_CERTIFICATE_P12" | base64 --decode > ios/certificate.p12
          echo "$IOS_PROVISIONING_PROFILE" | base64 --decode > ios/provisioning_profile.mobileprovision
          
          # Import certificate
          security create-keychain -p "" build.keychain
          security import ios/certificate.p12 -P "$IOS_CERTIFICATE_PASSWORD" -t cert -f pkcs12 -k build.keychain
          security set-keychain-settings build.keychain
          security unlock-keychain -p "" build.keychain
      
      - name: Build iOS
        run: flutter build ios --release --no-codesign
      
      - name: Build IPA
        run: |
          xcodebuild -workspace ios/Runner.xcworkspace \
                     -scheme Runner \
                     -configuration Release \
                     -archivePath build/Runner.xcarchive \
                     archive
          
          xcodebuild -exportArchive \
                     -archivePath build/Runner.xcarchive \
                     -exportPath build/ios \
                     -exportOptionsPlist ios/ExportOptions.plist
      
      - name: Upload to TestFlight
        env:
          IOS_API_KEY: ${{ secrets.IOS_API_KEY }}
          IOS_API_ISSUER: ${{ secrets.IOS_API_ISSUER }}
        run: |
          xcrun altool --upload-app \
                       --type ios \
                       --file build/ios/Runner.ipa \
                       --apiKey "$IOS_API_KEY" \
                       --apiIssuer "$IOS_API_ISSUER"

  build-web:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
      
      - name: Build Web
        run: |
          flutter build web --release --dart-define=FLUTTER_ENV=production
          
          # Optimize build
          cd build/web
          gzip -k -9 *.js *.css *.html
      
      - name: Deploy to Firebase
        if: github.ref == 'refs/heads/main'
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
        run: |
          npm install -g firebase-tools
          firebase deploy --token "$FIREBASE_TOKEN" --project materialpalette-prod
      
      - name: Deploy to Netlify
        if: github.ref == 'refs/heads/develop'
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        run: |
          npm install -g netlify-cli
          netlify deploy --dir=build/web --prod --auth="$NETLIFY_AUTH_TOKEN" --site="$NETLIFY_SITE_ID"
```

### Code Quality Pipeline
```yaml
# .github/workflows/quality.yml
name: Code Quality

on:
  pull_request:
    branches: [main, develop]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Generate code
        run: dart run build_runner build
      
      - name: Run Flutter analyzer
        run: flutter analyze
      
      - name: Check formatting
        run: dart format --set-exit-if-changed .
      
      - name: Run custom lints
        run: dart run custom_lint
  
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run security scan
        uses: securecodewarrior/github-action-add-sarif@v1
        with:
          sarif-file: 'security-scan-results.sarif'
```

## Platform-Specific Deployment

### iOS App Store Deployment
```yaml
# ios/ExportOptions.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

#### iOS Deployment Checklist
- [ ] Update version in `pubspec.yaml` and `ios/Runner/Info.plist`
- [ ] Generate and test iOS build locally
- [ ] Update App Store Connect metadata
- [ ] Submit for App Store Review
- [ ] Monitor TestFlight feedback
- [ ] Release to App Store after approval

### Android Play Store Deployment
```groovy
// android/app/build.gradle
android {
    defaultConfig {
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            ndk {
                debugSymbolLevel 'FULL'
            }
        }
    }
}
```

#### Android Deployment Checklist
- [ ] Update version in `pubspec.yaml`
- [ ] Build and test signed APK/AAB
- [ ] Upload to Play Console Internal Testing
- [ ] Test on multiple devices and Android versions
- [ ] Promote to Production track
- [ ] Monitor Play Console for crash reports

### Web Deployment Configuration
```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

## Release Management

### Versioning Strategy
Following Semantic Versioning (SemVer):
- **Major (X.0.0)**: Breaking changes, major feature releases
- **Minor (X.Y.0)**: New features, backwards compatible
- **Patch (X.Y.Z)**: Bug fixes, security updates

```bash
# Version bump commands
dart pub global activate cider
cider bump major    # 1.0.0 -> 2.0.0
cider bump minor    # 1.0.0 -> 1.1.0  
cider bump patch    # 1.0.0 -> 1.0.1
```

### Release Process
```bash
# 1. Prepare release
git checkout -b release/v1.2.0
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze

# 2. Update version
cider bump minor
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: bump version to 1.2.0"

# 3. Create release PR
git push origin release/v1.2.0
# Create PR to main branch

# 4. After PR approval and merge
git checkout main
git pull origin main
git tag v1.2.0
git push origin v1.2.0

# 5. Trigger deployment
# GitHub Actions will automatically deploy tagged releases
```

### Release Notes Template
```markdown
## v1.2.0 - 2024-01-15

### 🚀 New Features
- Added Material 3 color harmony algorithms
- Implemented accessibility color suggestions
- New export format: Adobe Swatch Exchange (.ase)

### 🐛 Bug Fixes
- Fixed contrast ratio calculation for edge cases
- Resolved navigation state persistence issue
- Corrected color picker touch targets on tablet

### 🔧 Improvements
- Improved color generation performance by 30%
- Enhanced responsive layout transitions
- Updated Material 3 color specifications

### 🔄 Changes
- Deprecated old color format exports
- Updated minimum Flutter version to 3.7.2

### 📱 Platform Support
- iOS: 13.0+
- Android: API level 21+
- Web: Modern browsers with ES6 support
```

## Monitoring & Rollback

### Application Monitoring
```dart
// lib/core/monitoring/app_monitoring.dart
class AppMonitoring {
  static void initialize() {
    // Crash reporting
    FlutterError.onError = (details) {
      // Send to crash reporting service
      CrashReporting.recordError(details.exception, details.stack);
    };
    
    // Performance monitoring
    PerformanceMonitoring.startSession();
    
    // User analytics (privacy-compliant)
    Analytics.setUserProperties({
      'platform': Platform.operatingSystem,
      'app_version': AppInfo.version,
    });
  }
  
  static void trackEvent(String event, Map<String, dynamic> parameters) {
    Analytics.logEvent(event, parameters);
  }
  
  static void recordError(dynamic error, StackTrace stackTrace) {
    CrashReporting.recordError(error, stackTrace);
  }
}
```

### Health Checks
```dart
// Web deployment health check endpoint
class HealthCheckService {
  static Map<String, dynamic> getHealthStatus() {
    return {
      'status': 'healthy',
      'version': AppInfo.version,
      'build_number': AppInfo.buildNumber,
      'timestamp': DateTime.now().toIso8601String(),
      'features': {
        'color_generation': true,
        'accessibility_validation': true,
        'export_functionality': true,
      },
    };
  }
}
```

### Rollback Procedures
```bash
# Emergency rollback for web deployment
firebase hosting:rollback --project materialpalette-prod

# Rollback mobile app (requires new release)
# 1. Revert problematic changes
git revert <commit-hash>

# 2. Create hotfix release
git checkout -b hotfix/v1.2.1
cider bump patch
git commit -am "hotfix: revert problematic changes"

# 3. Emergency deployment
git tag v1.2.1-hotfix
git push origin v1.2.1-hotfix
```

## Security & Secrets Management

### Secrets Configuration
```yaml
# GitHub Secrets (Repository Settings)
ANDROID_KEYSTORE          # Base64 encoded keystore file
ANDROID_KEY_PROPERTIES     # Key properties file content
GOOGLE_PLAY_SERVICE_ACCOUNT# Service account JSON
IOS_CERTIFICATE_P12        # Base64 encoded certificate
IOS_CERTIFICATE_PASSWORD   # Certificate password
IOS_PROVISIONING_PROFILE   # Base64 encoded provisioning profile
IOS_API_KEY               # App Store Connect API key
IOS_API_ISSUER            # API key issuer ID
FIREBASE_TOKEN            # Firebase deployment token
NETLIFY_AUTH_TOKEN        # Netlify deployment token
NETLIFY_SITE_ID           # Netlify site identifier
```

### Security Best Practices
```dart
// lib/core/security/security_config.dart
class SecurityConfig {
  // Certificate pinning for API calls
  static const List<String> pinnedCertificates = [
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
  ];
  
  // Content Security Policy for web
  static const String webCSP = 
    "default-src 'self'; "
    "script-src 'self' 'unsafe-inline' https://apis.google.com; "
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; "
    "font-src 'self' https://fonts.gstatic.com;";
    
  // Data sanitization
  static String sanitizeUserInput(String input) {
    return input.replaceAll(RegExp(r'[<>"\']'), '');
  }
}
```

### Code Signing Security
```bash
# iOS Code Signing
# Store certificates in CI/CD secrets, never in repository
security create-keychain -p "" build.keychain
security import certificate.p12 -P "$CERT_PASSWORD" -k build.keychain
security set-keychain-settings build.keychain
security unlock-keychain -p "" build.keychain

# Android Code Signing
# Store keystore and passwords in CI/CD secrets
echo "$ANDROID_KEYSTORE" | base64 --decode > android/app/keystore.jks
```

This comprehensive deployment guide ensures reliable, secure, and automated delivery of the Material 3 Color Explorer across all supported platforms.