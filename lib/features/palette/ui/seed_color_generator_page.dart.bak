import 'dart:math' show pi, cos, sin, atan2;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_color/app_color_seed_notifier.dart';

/// A page that allows users to generate and select color seeds for the app's theme.
///
/// This page provides multiple ways to select a color:
/// * A grid of predefined Material Design colors
/// * A color picker for custom color selection
/// * A text input for custom hex color values
/// * A random color generator
/// * A reset option to return to the default color
///
/// The selected color is managed by [ColorSeedNotifier] and will affect the app's
/// theme throughout the application.
@RoutePage(name: 'SeedColorGeneratorRoute')
class SeedColorGeneratorPage extends ConsumerWidget {
  /// Creates a [SeedColorGeneratorPage].
  const SeedColorGeneratorPage({super.key});

  /// A list of predefined Material Design colors available for selection.
  ///
  /// These colors are used to generate the color grid and serve as options
  /// for the random color generator.
  static const List<MaterialColor> materialColors = [
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
  ];

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
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(colorSeedNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Seed Generator'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Current Color: #${currentColor.r.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.g.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.b.round().toRadixString(16).padLeft(2, '0')}'
                      '${currentColor.a.round().toRadixString(16).padLeft(2, '0')}'
                  .toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: materialColors.length,
              itemBuilder: (context, index) {
                final color = materialColors[index];
                final isSelected =
                    currentColor.r.round() == color.r.round() &&
                    currentColor.g.round() == color.g.round() &&
                    currentColor.b.round() == color.b.round();

                return _ColorButton(
                  color: color,
                  isSelected: isSelected,
                  onPressed: () {
                    ref
                        .read(colorSeedNotifierProvider.notifier)
                        .updateColorSeed(color);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter hex color (e.g., #FF0000)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.colorize),
                      onPressed: () async {
                        final Color? newColor = await _showColorPicker(
                          context,
                          currentColor,
                        );
                        if (newColor != null) {
                          ref
                              .read(colorSeedNotifierProvider.notifier)
                              .updateColorSeed(newColor);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    ref
                        .read(colorSeedNotifierProvider.notifier)
                        .updateColorFromString(value);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        final randomColor =
                            materialColors[DateTime.now().millisecond %
                                materialColors.length];
                        ref
                            .read(colorSeedNotifierProvider.notifier)
                            .updateColorSeed(randomColor);
                      },
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Random'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
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
      Paint()..color = Colors.black.withOpacity(0.5),
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
  final MaterialColor color;

  /// Whether this color is currently selected.
  ///
  /// When true, displays a checkmark icon over the color.
  final bool isSelected;

  /// Callback function called when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [_ColorButton].
  ///
  /// All parameters are required:
  /// * [color]: The MaterialColor to display
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
