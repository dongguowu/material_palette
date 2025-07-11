import 'dart:math' show pi, cos, sin, atan2;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_color/app_color_seed_notifier.dart';

/// A page that allows users to generate and select color seeds for the app's theme.
///
/// This page provides multiple ways to select a color:
/// * A grid of dynamically generated colors from an expanded palette
/// * A color picker for custom color selection
/// * A text input for custom hex color values
/// * A random color generator that shuffles the grid
/// * A reset option to return to the default color
///
/// The selected color is managed by [ColorSeedNotifier] and will affect the app's
/// theme throughout the application.
@RoutePage(name: 'SeedColorGeneratorRoute')
class SeedColorGeneratorPage extends ConsumerStatefulWidget {
  /// Creates a [SeedColorGeneratorPage].
  const SeedColorGeneratorPage({super.key});

  @override
  ConsumerState<SeedColorGeneratorPage> createState() => _SeedColorGeneratorPageState();
}

class _SeedColorGeneratorPageState extends ConsumerState<SeedColorGeneratorPage> {
  /// Extended color palette for more variety
  static const List<Color> _extendedColorPalette = [
    // Original Material Colors
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    
    // Extended color variations
    Color(0xFF8E24AA), // Purple 600
    Color(0xFF5E35B1), // Deep Purple 600
    Color(0xFF3949AB), // Indigo 600
    Color(0xFF1E88E5), // Blue 600
    Color(0xFF039BE5), // Light Blue 600
    Color(0xFF00ACC1), // Cyan 600
    Color(0xFF00897B), // Teal 600
    Color(0xFF43A047), // Green 600
    Color(0xFF7CB342), // Light Green 600
    Color(0xFFA4C639), // Lime 600
    Color(0xFFD4E157), // Lime 300
    Color(0xFFFFEE58), // Yellow 300
    Color(0xFFFFCA28), // Amber 600
    Color(0xFFF57C00), // Orange 600
    Color(0xFFE64A19), // Deep Orange 600
    Color(0xFF8D6E63), // Brown 600
    Color(0xFF546E7A), // Blue Grey 600
    
    // Additional vibrant colors
    Color(0xFFFF4081), // Pink A200
    Color(0xFFE91E63), // Pink 500
    Color(0xFF9C27B0), // Purple 500
    Color(0xFF673AB7), // Deep Purple 500
    Color(0xFF3F51B5), // Indigo 500
    Color(0xFF2196F3), // Blue 500
    Color(0xFF03A9F4), // Light Blue 500
    Color(0xFF00BCD4), // Cyan 500
    Color(0xFF009688), // Teal 500
    Color(0xFF4CAF50), // Green 500
    Color(0xFF8BC34A), // Light Green 500
    Color(0xFFCDDC39), // Lime 500
    Color(0xFFFFEB3B), // Yellow 500
    Color(0xFFFFC107), // Amber 500
    Color(0xFFFF9800), // Orange 500
    Color(0xFFFF5722), // Deep Orange 500
    Color(0xFF795548), // Brown 500
    Color(0xFF607D8B), // Blue Grey 500
    
    // Softer tones
    Color(0xFFF8BBD9), // Pink 100
    Color(0xFFE1BEE7), // Purple 100
    Color(0xFFD1C4E9), // Deep Purple 100
    Color(0xFFC5CAE9), // Indigo 100
    Color(0xFFBBDEFB), // Blue 100
    Color(0xFFB3E5FC), // Light Blue 100
    Color(0xFFB2EBF2), // Cyan 100
    Color(0xFFB2DFDB), // Teal 100
    Color(0xFFC8E6C9), // Green 100
    Color(0xFFDCEDC8), // Light Green 100
    Color(0xFFF0F4C3), // Lime 100
    Color(0xFFFFF9C4), // Yellow 100
    Color(0xFFFFECB3), // Amber 100
    Color(0xFFFFE0B2), // Orange 100
    Color(0xFFFFCCBC), // Deep Orange 100
    Color(0xFFD7CCC8), // Brown 100
    Color(0xFFCFD8DC), // Blue Grey 100
    
    // Darker tones
    Color(0xFFAD1457), // Pink 800
    Color(0xFF6A1B9A), // Purple 800
    Color(0xFF4527A0), // Deep Purple 800
    Color(0xFF283593), // Indigo 800
    Color(0xFF1565C0), // Blue 800
    Color(0xFF0277BD), // Light Blue 800
    Color(0xFF00838F), // Cyan 800
    Color(0xFF00695C), // Teal 800
    Color(0xFF2E7D32), // Green 800
    Color(0xFF558B2F), // Light Green 800
    Color(0xFF9E9D24), // Lime 800
    Color(0xFFF9A825), // Yellow 800
    Color(0xFFFF8F00), // Amber 800
    Color(0xFFEF6C00), // Orange 800
    Color(0xFFD84315), // Deep Orange 800
    Color(0xFF5D4037), // Brown 800
    Color(0xFF455A64), // Blue Grey 800
  ];

  /// Current display colors (18 colors shown in grid)
  late List<Color> _displayColors;
  
  /// Mode toggle: true = Seed Mode, false = Primary Mode
  bool _isSeedMode = true;
  
  /// Selected primary color in Primary Mode
  Color? _selectedPrimaryColor;

  @override
  void initState() {
    super.initState();
    _shuffleColors();
  }

  /// Shuffles the colors to display 18 random colors from the extended palette
  void _shuffleColors() {
    final shuffled = List<Color>.from(_extendedColorPalette);
    shuffled.shuffle();
    _displayColors = shuffled.take(18).toList();
  }
  
  /// Calculates the optimal seed color from a desired primary color
  /// In Material 3, this is typically the same color, but we can apply
  /// slight adjustments for better color scheme generation
  Color _calculateSeedFromPrimary(Color primaryColor) {
    // For most cases, the primary color IS the seed color in Material 3
    // But we can apply slight HSV adjustments for better scheme generation
    final hsv = HSVColor.fromColor(primaryColor);
    
    // Slightly adjust saturation and value for optimal scheme generation
    final adjustedHsv = hsv.withSaturation(
      (hsv.saturation * 0.9).clamp(0.3, 1.0),
    ).withValue(
      (hsv.value * 0.95).clamp(0.4, 1.0),
    );
    
    return adjustedHsv.toColor();
  }
  
  /// Applies the calculated seed color from primary color selection
  void _applyPrimaryColorSelection(Color primaryColor) {
    _selectedPrimaryColor = primaryColor;
    final seedColor = _calculateSeedFromPrimary(primaryColor);
    ref.read(colorSeedNotifierProvider.notifier).updateColorSeed(seedColor);
  }

  /// Shows a color picker dialog for custom color selection.
  ///
  /// Returns the selected color or null if the dialog is dismissed.
  Future<Color?> _showColorPicker(BuildContext context, Color initialColor) {
    Color pickerColor = initialColor;
    final ValueNotifier<double> brightnessNotifier = ValueNotifier(
      HSVColor.fromColor(initialColor).value,
    );

    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color wheel picker
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Color wheel
                      ValueListenableBuilder<double>(
                        valueListenable: brightnessNotifier,
                        builder: (context, brightness, _) {
                          return _ColorWheel(
                            currentColor: pickerColor,
                            brightness: brightness,
                            onColorChanged: (color) {
                              pickerColor = color;
                              (context as Element).markNeedsBuild();
                            },
                          );
                        },
                      ),
                      // Brightness slider (circular)
                      Positioned(
                        right: 0,
                        child: SizedBox(
                          height: 280,
                          width: 32,
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 12,
                                activeTrackColor: Colors.grey[300],
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withAlpha(32),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                              ),
                              child: Slider(
                                value: brightnessNotifier.value,
                                onChanged: (value) {
                                  brightnessNotifier.value = value;
                                  final hsv = HSVColor.fromColor(pickerColor);
                                  pickerColor = hsv.withValue(value).toColor();
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Color preview
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: pickerColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
                // Hex color display
                Text(
                  '#${pickerColor.r.round().toRadixString(16).padLeft(2, '0')}'
                          '${pickerColor.g.round().toRadixString(16).padLeft(2, '0')}'
                          '${pickerColor.b.round().toRadixString(16).padLeft(2, '0')}'
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () => Navigator.of(context).pop(pickerColor),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = ref.watch(colorSeedNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSeedMode ? 'Color Seed Generator' : 'Primary Color Selector'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              setState(() {
                _shuffleColors();
              });
            },
            tooltip: 'Shuffle Colors',
          ),
          IconButton(
            icon: Icon(_isSeedMode ? Icons.palette : Icons.colorize),
            onPressed: () {
              setState(() {
                _isSeedMode = !_isSeedMode;
                _selectedPrimaryColor = null;
              });
            },
            tooltip: _isSeedMode ? 'Switch to Primary Mode' : 'Switch to Seed Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode Toggle Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isSeedMode ? Icons.colorize : Icons.palette,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSeedMode ? 'Seed Color Mode' : 'Primary Color Mode',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSeedMode
                        ? 'Select a seed color to generate the complete Material 3 color scheme'
                        : 'Select your desired primary color and we\'ll calculate the optimal seed color',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (!_isSeedMode && _selectedPrimaryColor != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Primary: ', style: Theme.of(context).textTheme.bodyMedium),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectedPrimaryColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: colorScheme.outline),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('→', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 8),
                        Text('Seed: ', style: Theme.of(context).textTheme.bodyMedium),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: colorScheme.outline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Current Color Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Current ${_isSeedMode ? 'Seed' : 'Generated'} Color: #${currentColor.r.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.g.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.b.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.a.round().toRadixString(16).padLeft(2, '0')}'
                  .toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          
          // Color Scheme Preview (only in Primary Mode)
          if (!_isSeedMode) ...[
            const SizedBox(height: 16),
            _buildColorSchemePreview(context, colorScheme),
          ],
          
          // Color Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _displayColors.length,
              itemBuilder: (context, index) {
                final color = _displayColors[index];
                final isSelected = _isSeedMode
                    ? (currentColor.r.round() == color.r.round() &&
                       currentColor.g.round() == color.g.round() &&
                       currentColor.b.round() == color.b.round())
                    : (_selectedPrimaryColor != null &&
                       _selectedPrimaryColor!.r.round() == color.r.round() &&
                       _selectedPrimaryColor!.g.round() == color.g.round() &&
                       _selectedPrimaryColor!.b.round() == color.b.round());

                return _ColorButton(
                  color: color,
                  isSelected: isSelected,
                  onPressed: () {
                    if (_isSeedMode) {
                      ref
                          .read(colorSeedNotifierProvider.notifier)
                          .updateColorSeed(color);
                    } else {
                      _applyPrimaryColorSelection(color);
                    }
                  },
                );
              },
            ),
          ),
          
          // Bottom Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: _isSeedMode 
                        ? 'Enter hex color (e.g., #FF0000)'
                        : 'Enter primary color hex (e.g., #FF0000)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.colorize),
                      onPressed: () async {
                        final Color? newColor = await _showColorPicker(
                          context,
                          currentColor,
                        );
                        if (newColor != null) {
                          if (_isSeedMode) {
                            ref
                                .read(colorSeedNotifierProvider.notifier)
                                .updateColorSeed(newColor);
                          } else {
                            _applyPrimaryColorSelection(newColor);
                          }
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (_isSeedMode) {
                      ref
                          .read(colorSeedNotifierProvider.notifier)
                          .updateColorFromString(value);
                    } else {
                      final color = _parseColorFromString(value);
                      if (color != null) {
                        _applyPrimaryColorSelection(color);
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final randomColor = _extendedColorPalette[
                            DateTime.now().millisecondsSinceEpoch %
                                _extendedColorPalette.length];
                        if (_isSeedMode) {
                          ref
                              .read(colorSeedNotifierProvider.notifier)
                              .updateColorSeed(randomColor);
                        } else {
                          _applyPrimaryColorSelection(randomColor);
                        }
                      },
                      icon: const Icon(Icons.casino),
                      label: const Text('Random'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _shuffleColors();
                        });
                      },
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Shuffle Grid'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedPrimaryColor = null;
                        });
                        ref
                            .read(colorSeedNotifierProvider.notifier)
                            .updateColorSeed(
                              ColorSeedNotifier.defaultColorSeed,
                            );
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a color scheme preview widget
  Widget _buildColorSchemePreview(BuildContext context, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generated Color Scheme Preview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildColorPreviewChip('Primary', colorScheme.primary, colorScheme.onPrimary),
              _buildColorPreviewChip('Secondary', colorScheme.secondary, colorScheme.onSecondary),
              _buildColorPreviewChip('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
              _buildColorPreviewChip('Surface', colorScheme.surface, colorScheme.onSurface),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a small color preview chip
  Widget _buildColorPreviewChip(String label, Color color, Color onColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: onColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Parses a color string to Color object (helper method)
  Color? _parseColorFromString(String colorString) {
    final hexString = colorString.replaceFirst('#', '');
    try {
      if (hexString.length == 6) {
        return Color(int.parse('FF$hexString', radix: 16));
      } else if (hexString.length == 8) {
        return Color(int.parse(hexString, radix: 16));
      }
    } catch (e) {
      // Invalid color string
    }
    return null;
  }
}

/// A custom painter that draws a color wheel for color selection.
class _ColorWheel extends StatefulWidget {
  final Color currentColor;
  final double brightness;
  final ValueChanged<Color> onColorChanged;

  const _ColorWheel({
    required this.currentColor,
    required this.brightness,
    required this.onColorChanged,
  });

  @override
  State<_ColorWheel> createState() => _ColorWheelState();
}

class _ColorWheelState extends State<_ColorWheel> {
  late HSVColor _currentHsv;
  late Offset _currentPosition;
  final double _padding = 16.0;

  @override
  void initState() {
    super.initState();
    _currentHsv = HSVColor.fromColor(widget.currentColor);
    _updatePosition();
  }

  @override
  void didUpdateWidget(_ColorWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentColor != widget.currentColor ||
        oldWidget.brightness != widget.brightness) {
      _currentHsv = HSVColor.fromColor(
        widget.currentColor,
      ).withValue(widget.brightness);
      _updatePosition();
    }
  }

  void _updatePosition() {
    final double radius = _currentHsv.saturation * ((280 - _padding * 2) / 2);
    final double angle = _currentHsv.hue * pi / 180;
    _currentPosition = Offset(radius * cos(angle), radius * sin(angle));
  }

  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    _updateColorFromPosition(details.globalPosition, constraints);
  }

  void _handlePanStart(DragStartDetails details, BoxConstraints constraints) {
    _updateColorFromPosition(details.globalPosition, constraints);
  }

  void _updateColorFromPosition(
    Offset globalPosition,
    BoxConstraints constraints,
  ) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    final Offset center = Offset(
      constraints.maxWidth / 2,
      constraints.maxHeight / 2,
    );
    final Offset relativePosition = localPosition - center;

    // Calculate hue and saturation from the position
    final double angle =
        (atan2(relativePosition.dy, relativePosition.dx) * 180 / pi) % 360;
    final double radius = relativePosition.distance;
    final double maxRadius = (constraints.maxWidth - _padding * 2) / 2;
    final double saturation = (radius / maxRadius).clamp(0.0, 1.0);

    _currentHsv = HSVColor.fromAHSV(1.0, angle, saturation, widget.brightness);
    _currentPosition = relativePosition;
    widget.onColorChanged(_currentHsv.toColor());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (details) => _handlePanStart(details, constraints),
          onPanUpdate: (details) => _handlePanUpdate(details, constraints),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _ColorWheelPainter(
              padding: _padding,
              brightness: widget.brightness,
              currentPosition: _currentPosition,
            ),
          ),
        );
      },
    );
  }
}

/// A custom painter that draws the color wheel and selector.
class _ColorWheelPainter extends CustomPainter {
  final double padding;
  final double brightness;
  final Offset currentPosition;

  _ColorWheelPainter({
    required this.padding,
    required this.brightness,
    required this.currentPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - padding * 2) / 2;

    // Draw color wheel
    for (double angle = 0; angle < 360; angle += 1) {
      final double radian = angle * pi / 180;
      final Paint paint = Paint()..style = PaintingStyle.fill;

      for (double saturation = 0; saturation <= 1.0; saturation += 0.02) {
        final Color color =
            HSVColor.fromAHSV(1.0, angle, saturation, brightness).toColor();

        paint.color = color;

        final double r = radius * saturation;
        final Offset p1 = center + Offset(r * cos(radian), r * sin(radian));
        canvas.drawCircle(p1, 1, paint);
      }
    }

    // Draw selector
    final Paint selectorPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawCircle(center + currentPosition, 8, selectorPaint);

    canvas.drawCircle(
      center + currentPosition,
      7,
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(_ColorWheelPainter oldDelegate) =>
      oldDelegate.brightness != brightness ||
      oldDelegate.currentPosition != currentPosition;
}

/// A custom button widget that displays a color swatch and indicates selection.
///
/// This is a private widget used by [SeedColorGeneratorPage] to display individual
/// color options in the color grid.
class _ColorButton extends StatelessWidget {
  /// The color to display in the button.
  final Color color;

  /// Whether this color is currently selected.
  ///
  /// When true, displays a checkmark icon over the color.
  final bool isSelected;

  /// Callback function called when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [_ColorButton].
  ///
  /// All parameters are required:
  /// * [color]: The Color to display
  /// * [isSelected]: Whether this color is currently selected
  /// * [onPressed]: Callback function when the button is pressed
  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child:
            isSelected
                ? const Center(child: Icon(Icons.check, color: Colors.white))
                : null,
      ),
    );
  }
}
