import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_palette/features/app/app_layout/active_tab_notifier.dart';

@RoutePage(name: 'AboutRoute')
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(title: Text('About')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Material Palette',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Material Palette is an innovative app designed to help users explore and apply Material Design colors effortlessly. Users can select a seed color, and the app dynamically generates a cohesive color scheme that aligns with Material Design principles.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  'Author: Dongguo WU',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: dongguo.wu@94050105.xyz',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(activeTabIndexProvider.notifier)
                        .updateActiveTabIndex(0);
                  },
                  child: Text('Back'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
