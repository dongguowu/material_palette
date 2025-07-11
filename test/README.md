# Test Configuration for Material Palette

## Running Tests

To run all tests:
```bash
flutter test
```

To run specific test files:
```bash
# Test color seed notifier state
flutter test test/features/app/app_color/app_color_seed_notifier_test.dart

# Test seed generator UI and state
flutter test test/features/palette/ui/seed_color_generator_test.dart
```

To run tests with coverage:
```bash
flutter test --coverage
```

## Test Structure

### Unit Tests
- `app_color_seed_notifier_test.dart`: Tests the color seed state management
- `test_helpers.dart`: Utility functions for testing

### Widget Tests  
- `seed_color_generator_test.dart`: Tests the UI state changes and user interactions

## Test Categories

### State Management Tests
✅ Mode toggle (_isSeedMode state)
✅ Color selection and updates
✅ Primary color to seed color calculation
✅ Color shuffling functionality
✅ HSV color calculation logic
✅ Provider state notifications

### UI Interaction Tests
✅ Mode toggle button functionality
✅ Color scheme preview visibility
✅ Text label updates based on mode
✅ Color grid selection
✅ Shuffle and reset functionality

### Edge Case Tests
✅ Invalid hex color input handling
✅ Color parsing (RGB vs ARGB)
✅ HSV calculation edge cases (black/white)
✅ State persistence across rebuilds

## Test Data

Common test colors used:
- Red: `#FF0000` / `Color(0xFFFF0000)`
- Green: `#00FF00` / `Color(0xFF00FF00)`  
- Blue: `#0000FF` / `Color(0xFF0000FF)`
- White: `#FFFFFF` / `Color(0xFFFFFFFF)`
- Black: `#000000` / `Color(0xFF000000)`

## Coverage Goals

Target: 90%+ test coverage for:
- State management logic
- Color calculation algorithms  
- UI state transitions
- Error handling paths