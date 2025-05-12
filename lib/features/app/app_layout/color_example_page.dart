import 'package:flutter/material.dart';

class ColorExamplePage extends StatefulWidget {
  const ColorExamplePage({super.key});
  static String label = "Color";

  @override
  State<ColorExamplePage> createState() => _ColorExamplePageState();
}

class _ColorExamplePageState extends State<ColorExamplePage>
    with AutomaticKeepAliveClientMixin {
  //  tells the framework to keep this widget alive even when it's not visible.
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Define the color map.  This is the *KEY* improvement.
    final Map<String, ({Color color, Color onColor})> colorMap = {
      'Primary': (color: colorScheme.primary, onColor: colorScheme.onPrimary),
      'Primary Container': (
        color: colorScheme.primaryContainer,
        onColor: colorScheme.onPrimaryContainer,
      ),
      'Secondary': (
        color: colorScheme.secondary,
        onColor: colorScheme.onSecondary,
      ),
      'Secondary Container': (
        color: colorScheme.secondaryContainer,
        onColor: colorScheme.onSecondaryContainer,
      ),
      'Surface': (color: colorScheme.surface, onColor: colorScheme.onSurface),
      'Surface Variant': (
        color: colorScheme.surfaceContainerHighest,
        onColor: colorScheme.onSurfaceVariant,
      ),
      'Surface Container': (
        color: colorScheme.surfaceContainer,
        onColor: colorScheme.onSurface,
      ),
      'Surface Container High': (
        color: colorScheme.surfaceContainerHigh,
        onColor: colorScheme.onSurface,
      ),
      'Surface Container Highest': (
        color: colorScheme.surfaceContainerHighest,
        onColor: colorScheme.onSurface,
      ),
      'Inverse Surface': (
        color: colorScheme.inverseSurface,
        onColor: colorScheme.onInverseSurface,
      ),
      'Background': (
        color: colorScheme.surface,
        onColor: colorScheme.onSurface,
      ),
      'Error': (color: colorScheme.error, onColor: colorScheme.onError),
      'Error Container': (
        color: colorScheme.errorContainer,
        onColor: colorScheme.onErrorContainer,
      ),
      'Outline': (color: colorScheme.outline, onColor: colorScheme.onSurface),
      'Outline Variant': (
        color: colorScheme.outlineVariant,
        onColor: colorScheme.onSurface,
      ),
      'Shadow': (color: colorScheme.shadow, onColor: colorScheme.onSurface),
    };

    // Group the colors for display.  This makes it easy to add/remove sections.
    final Map<String, List<String>> colorSections = {
      'Primary Colors': ['Primary', 'Primary Container'],
      'Secondary Colors': ['Secondary', 'Secondary Container'],
      'Surface Colors': [
        'Surface',
        'Surface Variant',
        'Surface Container',
        'Surface Container High',
        'Surface Container Highest',
        'Inverse Surface',
      ],
      'Background Colors': ['Background'],
      'Error Colors': ['Error', 'Error Container'],
      'Outline Colors': ['Outline', 'Outline Variant'],
      'Shadow Colors': ['Shadow'],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Material 3 Colors'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: colorSections.entries.map((sectionEntry) {
                return _buildColorSection(
                  sectionEntry.key,
                  sectionEntry.value.map((colorKey) {
                    // Look up the color data from the colorMap.
                    final colorData = colorMap[colorKey];
                    // Handle the (unlikely) case where the key isn't found.
                    if (colorData == null) {
                      return const SizedBox.shrink(); // Or some error handling
                    }
                    return _buildColorCard(
                      colorKey, // The label is the key
                      colorData.color,
                      colorData.onColor,
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildColorCard(String label, Color color, Color textColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color, // Button background
                    foregroundColor:
                        textColor, // Button text color (and ripple color)
                  ),
                  onPressed: () {},
                  child: const Text('material defined'),
                ),
                ElevatedButton(onPressed: () {}, child: const Text('default')),
              ],
            ),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
