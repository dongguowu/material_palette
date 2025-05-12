import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_router/app_router.gr.dart';

class RootHelper {
  final Widget child = Center();

  static List<PageRouteInfo<Object?>> routes = [
    const HomeRoute(), // 0
    const HomeRoute(), // 0
    const HomeRoute(), // 0
    const AboutRoute(), // 0
    // TemperatureHistoryRoute(vehicleId: '123'), // 2
    // SensorDataRoute(), // 2
    // const MarkerListRoute(), // 2.1
    // const GeogMapRoute(), // 3
    // const ThemeSettingsRoute(), // 3
    // VehicleMapRoute(trailerId: '123') //5
  ];

  static List<NavigationDestination> destinations = <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.list), label: "Vehicles"),
    NavigationDestination(icon: Icon(Icons.thermostat), label: "Temp Control"),
    NavigationDestination(icon: Icon(Icons.history), label: "Temp History"),
    NavigationDestination(icon: Icon(Icons.map), label: "Map"),
  ];
}
