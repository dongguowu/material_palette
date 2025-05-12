import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'material_3_design_helper.dart';

@RoutePage(name: 'ColorHelperRoute')
class Material3ColorHelperPage extends StatelessWidget {
  const Material3ColorHelperPage({super.key});

  Widget _buildColorCard(
    BuildContext context,
    String name,
    Color color,
    Color textColor,
  ) {
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Material3ColorHelper.colorRoles[name] ?? '',
                    style: TextStyle(
                      color: textColor.withAlpha(204),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: textColor.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${color.r.round().toRadixString(16).padLeft(2, '0')}'
                        '${color.g.round().toRadixString(16).padLeft(2, '0')}'
                        '${color.b.round().toRadixString(16).padLeft(2, '0')}'
                        '${color.a.round().toRadixString(16).padLeft(2, '0')}'
                    .toUpperCase(),
                style: TextStyle(color: textColor, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...children,
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUsageExample(
    BuildContext context,
    String title,
    Widget example,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
          example,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Material 3 Color System'),
        backgroundColor: colorScheme.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'The Material 3 color system helps create dynamic and accessible color themes. Here\'s how to use it effectively in your Flutter applications:',
                style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              ),
            ),

            // Core Color Roles
            _buildSection('Core Color Roles', [
              _buildColorCard(
                context,
                'Primary',
                colorScheme.primary,
                colorScheme.onPrimary,
              ),
              _buildColorCard(
                context,
                'Secondary',
                colorScheme.secondary,
                colorScheme.onSecondary,
              ),
              _buildColorCard(
                context,
                'Tertiary',
                colorScheme.tertiary,
                colorScheme.onTertiary,
              ),
              _buildColorCard(
                context,
                'Surface',
                colorScheme.surface,
                colorScheme.onSurface,
              ),
            ]),

            // Usage Examples
            _buildSection(
              'Common Usage Examples',
              Material3ColorHelper.commonUsageExamples.entries
                  .map(
                    (e) => _buildUsageExample(context, e.key, e.value(context)),
                  )
                  .toList(),
            ),

            // Best Practices
            _buildSection('Best Practices', [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children:
                      Material3ColorHelper.bestPractices
                          .map(
                            (practice) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      practice,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ]),

            // Interactive States
            _buildSection('Interactive States', [
              _buildUsageExample(
                context,
                'Button States',
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Normal')),
                    ElevatedButton(onPressed: null, child: Text('Disabled')),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary.withAlpha(
                          (0.8 * 255).round(),
                        ),
                      ),
                      onPressed: () {},
                      child: Text('Pressed'),
                    ),
                  ],
                ),
              ),
            ]),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
