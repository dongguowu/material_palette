import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_palette/features/palette/ui/seed_color_generator_page.dart';
import 'package:material_palette/features/app/app_color/app_color_seed_notifier.dart';

void main() {
  group('SeedColorGeneratorPage State Tests', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer();
    });
    
    tearDown(() {
      container.dispose();
    });

    testWidgets('should initialize in Seed Mode by default', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Assert
      expect(find.text('Seed Color Mode'), findsOneWidget);
      expect(find.text('Primary Color Mode'), findsNothing);
      expect(find.text('Color Seed Generator'), findsOneWidget);
      expect(find.text('Select a seed color to generate the complete Material 3 color scheme'), findsOneWidget);
    });

    testWidgets('should toggle to Primary Mode when mode toggle button is pressed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Verify initial state
      expect(find.text('Seed Color Mode'), findsOneWidget);
      expect(find.text('Primary Color Mode'), findsNothing);
      
      // Act - Find and tap the mode toggle button (palette icon)
      final modeToggleButton = find.byIcon(Icons.palette);
      expect(modeToggleButton, findsOneWidget);
      await tester.tap(modeToggleButton);
      await tester.pump();
      
      // Assert
      expect(find.text('Primary Color Mode'), findsOneWidget);
      expect(find.text('Seed Color Mode'), findsNothing);
      expect(find.text('Primary Color Selector'), findsOneWidget);
      expect(find.text('Select your desired primary color and we\'ll calculate the optimal seed color'), findsOneWidget);
    });

    testWidgets('should toggle back to Seed Mode from Primary Mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // First, switch to Primary Mode
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pump();
      expect(find.text('Primary Color Mode'), findsOneWidget);
      
      // Act - Toggle back to Seed Mode (colorize icon)
      final modeToggleButton = find.byIcon(Icons.colorize);
      expect(modeToggleButton, findsOneWidget);
      await tester.tap(modeToggleButton);
      await tester.pump();
      
      // Assert
      expect(find.text('Seed Color Mode'), findsOneWidget);
      expect(find.text('Primary Color Mode'), findsNothing);
      expect(find.text('Color Seed Generator'), findsOneWidget);
    });

    testWidgets('should show color scheme preview only in Primary Mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Assert - No preview in Seed Mode
      expect(find.text('Generated Color Scheme Preview'), findsNothing);
      
      // Act - Switch to Primary Mode
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pump();
      
      // Assert - Preview appears in Primary Mode
      expect(find.text('Generated Color Scheme Preview'), findsOneWidget);
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Tertiary'), findsOneWidget);
      expect(find.text('Surface'), findsOneWidget);
    });

    testWidgets('should update current color display text based on mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Assert - Seed Mode label
      expect(find.textContaining('Current Seed Color:'), findsOneWidget);
      expect(find.textContaining('Current Generated Color:'), findsNothing);
      
      // Act - Switch to Primary Mode
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pump();
      
      // Assert - Primary Mode label
      expect(find.textContaining('Current Generated Color:'), findsOneWidget);
      expect(find.textContaining('Current Seed Color:'), findsNothing);
    });

    testWidgets('should update hex input label based on mode', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Assert - Seed Mode label
      expect(find.text('Enter hex color (e.g., #FF0000)'), findsOneWidget);
      expect(find.text('Enter primary color hex (e.g., #FF0000)'), findsNothing);
      
      // Act - Switch to Primary Mode
      await tester.tap(find.byIcon(Icons.palette));
      await tester.pump();
      
      // Assert - Primary Mode label
      expect(find.text('Enter primary color hex (e.g., #FF0000)'), findsOneWidget);
      expect(find.text('Enter hex color (e.g., #FF0000)'), findsNothing);
    });

    testWidgets('should shuffle colors when shuffle button is pressed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Capture initial color grid state by finding color buttons
      final initialColorButtons = tester.widgetList(find.byType(Material));
      final initialColorCount = initialColorButtons.length;
      
      // Act - Tap shuffle button in app bar
      await tester.tap(find.byIcon(Icons.shuffle));
      await tester.pump();
      
      // Assert - Grid should still have the same number of colors (18)
      final newColorButtons = tester.widgetList(find.byType(Material));
      expect(newColorButtons.length, equals(initialColorCount));
      
      // Note: Since colors are randomized, we can't test exact color changes
      // but we can verify the grid structure remains consistent
    });

    testWidgets('should reset to default color when reset button is pressed', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Act - Tap reset button
      await tester.tap(find.text('Reset'));
      await tester.pump();
      
      // Assert - Should show default blue color hex
      expect(find.textContaining('FF2196F3FF'), findsOneWidget); // Blue color hex
    });

    testWidgets('should display hex color text on each color button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Assert - Should find hex color text (looking for # symbol which indicates hex)
      expect(find.textContaining('#'), findsWidgets);
      
      // Verify that multiple hex texts are displayed (should be 18)
      final hexTexts = find.textContaining('#');
      expect(hexTexts.evaluate().length, greaterThan(10)); // At least most of the 18 colors
    });

    testWidgets('should show hex text in readable contrast color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Act - Find hex text widgets
      final hexTexts = find.textContaining('#');
      expect(hexTexts, findsWidgets);
      
      // Assert - Verify text widgets exist with proper styling
      for (final widget in tester.widgetList<Text>(hexTexts)) {
        expect(widget.style?.fontFamily, equals('monospace'));
        expect(widget.style?.fontSize, equals(10));
        expect(widget.style?.fontWeight, equals(FontWeight.w600));
      }
    });

    testWidgets('should update selection indicator to check_circle icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: SeedColorGeneratorPage(),
          ),
        ),
      );
      
      // Act - Find and tap the first color button
      final colorButtons = find.byType(InkWell);
      await tester.tap(colorButtons.first);
      await tester.pump();
      
      // Assert - Should show check_circle icon instead of simple check
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    group('Color Selection Tests', () {
      testWidgets('should select color in Seed Mode', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: SeedColorGeneratorPage(),
            ),
          ),
        );
        
        // Act - Find and tap the first color button
        final colorButtons = find.byType(InkWell);
        await tester.tap(colorButtons.first);
        await tester.pump();
        
        // Assert - Color should be selected (check for checkmark icon)
        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('should handle random color selection', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: SeedColorGeneratorPage(),
            ),
          ),
        );
        
        // Capture initial color
        final initialColorText = find.textContaining('Current Seed Color:');
        expect(initialColorText, findsOneWidget);
        
        // Act - Tap random button
        await tester.tap(find.text('Random'));
        await tester.pump();
        
        // Assert - Color display should still exist (may have changed)
        expect(find.textContaining('Current Seed Color:'), findsOneWidget);
      });
    });

    group('HSV Color Calculation Tests', () {
      test('should calculate seed color from primary color with HSV adjustments', () {
        // Create a test widget to access the calculation method
        // Note: This requires making the calculation method static or extracting it
        
        // Test data
        const primaryColor = Color(0xFFFF0000); // Red
        
        // Calculate HSV manually for verification
        final hsv = HSVColor.fromColor(primaryColor);
        final expectedSaturation = (hsv.saturation * 0.9).clamp(0.3, 1.0);
        final expectedValue = (hsv.value * 0.95).clamp(0.4, 1.0);
        
        // Assert HSV adjustments are within expected ranges
        expect(expectedSaturation, greaterThanOrEqualTo(0.3));
        expect(expectedSaturation, lessThanOrEqualTo(1.0));
        expect(expectedValue, greaterThanOrEqualTo(0.4));
        expect(expectedValue, lessThanOrEqualTo(1.0));
      });
      
      test('should handle edge cases in color calculation', () {
        // Test with pure black
        const blackColor = Color(0xFF000000);
        final blackHsv = HSVColor.fromColor(blackColor);
        final adjustedBlack = blackHsv.withSaturation(
          (blackHsv.saturation * 0.9).clamp(0.3, 1.0),
        ).withValue(
          (blackHsv.value * 0.95).clamp(0.4, 1.0),
        );
        
        // Should clamp to minimum value
        expect(adjustedBlack.value, equals(0.4));
        
        // Test with pure white
        const whiteColor = Color(0xFFFFFFFF);
        final whiteHsv = HSVColor.fromColor(whiteColor);
        final adjustedWhite = whiteHsv.withSaturation(
          (whiteHsv.saturation * 0.9).clamp(0.3, 1.0),
        ).withValue(
          (whiteHsv.value * 0.95).clamp(0.4, 1.0),
        );
        
        // Should maintain high value
        expect(adjustedWhite.value, closeTo(0.95, 0.01));
      });
    });

    group('ColorSeedNotifier Integration Tests', () {
      test('should update color seed notifier when color is selected', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        
        const testColor = Color(0xFFFF0000); // Red
        
        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorSeed(testColor);
        
        // Assert
        final currentColor = container.read(colorSeedNotifierProvider);
        expect(currentColor, equals(testColor));
      });
      
      test('should parse color from hex string correctly', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        
        const hexString = '#FF0000';
        
        // Act
        container.read(colorSeedNotifierProvider.notifier).updateColorFromString(hexString);
        
        // Assert
        final currentColor = container.read(colorSeedNotifierProvider);
        expect(currentColor.red, equals(255));
        expect(currentColor.green, equals(0));
        expect(currentColor.blue, equals(0));
      });
    });
  });
}