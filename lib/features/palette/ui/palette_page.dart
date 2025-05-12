import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'HomeRoute')
class PalettePage extends StatelessWidget {
  const PalettePage({super.key});

  Widget _buildColorRoleCard(
    String title,
    String description,
    Color backgroundColor,
    Color textColor,
  ) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: textColor.withAlpha(204)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorExample(BuildContext context, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text('Material Color Roles'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.of(context).pushNamed('/about'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Color roles',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Depending on the purpose in a UI, key colors are assigned roles that map to elements in components. The five essential color groups with role assignments are:',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withAlpha(204),
                ),
              ),
              SizedBox(height: 24),
              _buildColorRoleCard(
                'Primary',
                'Main brand color, used for key UI elements',
                colorScheme.primary,
                colorScheme.onPrimary,
              ),
              _buildColorRoleCard(
                'Secondary',
                'Complementary color for accents and floating action buttons',
                colorScheme.secondary,
                colorScheme.onSecondary,
              ),
              _buildColorRoleCard(
                'Tertiary',
                'Additional accent color for special components',
                colorScheme.tertiary,
                colorScheme.onTertiary,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 24),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Color Role Examples',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildColorExample(
                      context,
                      '*.background',
                      colorScheme.surface,
                    ),
                    _buildColorExample(
                      context,
                      '*.tertiary',
                      colorScheme.tertiary,
                    ),
                    _buildColorExample(
                      context,
                      '*.tertiary-container',
                      colorScheme.tertiaryContainer,
                    ),
                    _buildColorExample(
                      context,
                      '*.on-surface',
                      colorScheme.onSurface,
                    ),
                    _buildColorExample(
                      context,
                      '*.primary90',
                      colorScheme.primary,
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    // Implement color scheme generation functionality
                  },
                  icon: Icon(Icons.color_lens),
                  label: Text('Generate Color Scheme'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
