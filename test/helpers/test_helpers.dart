import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Test helper utilities for widget testing
class TestHelpers {
  /// Creates a MaterialApp wrapper with ProviderScope for testing widgets
  static Widget createTestApp({
    required Widget child,
    ProviderContainer? container,
  }) {
    return ProviderScope(
      parent: container,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  /// Finds a widget by its text content
  static Finder findTextContaining(String text) {
    return find.byWidgetPredicate(
      (widget) => widget is Text && widget.data != null && widget.data!.contains(text),
    );
  }

  /// Pumps widget and settles all animations
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Taps a widget and pumps the frame
  static Future<void> tapAndPump(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Enters text in a text field and pumps the frame
  static Future<void> enterTextAndPump(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }
}

/// Color test utilities
class ColorTestUtils {
  /// Converts Color to hex string for testing
  static String colorToHex(Color color) {
    return '#${color.r.round().toRadixString(16).padLeft(2, '0')}'
           '${color.g.round().toRadixString(16).padLeft(2, '0')}'
           '${color.b.round().toRadixString(16).padLeft(2, '0')}'
           '${color.a.round().toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }

  /// Creates a test color from RGB values
  static Color createTestColor(int red, int green, int blue, [int alpha = 255]) {
    return Color.fromARGB(alpha, red, green, blue);
  }

  /// Common test colors
  static const Color testRed = Color(0xFFFF0000);
  static const Color testGreen = Color(0xFF00FF00);
  static const Color testBlue = Color(0xFF0000FF);
  static const Color testWhite = Color(0xFFFFFFFF);
  static const Color testBlack = Color(0xFF000000);
}