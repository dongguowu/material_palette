// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:material_palette/features/app/app_layout/navigation_error_page.dart'
    as _i1;
import 'package:material_palette/features/app/app_layout/root_screen_adaptive_layout.dart'
    as _i4;
import 'package:material_palette/features/app/app_pages/not_found_page.dart'
    as _i2;
import 'package:material_palette/features/app/app_themes/ui/dark_switch_page.dart'
    as _i5;
import 'package:material_palette/features/palette/ui/palette_page.dart' as _i3;

/// generated route for
/// [_i1.NavigationErrorPage]
class NavigationErrorRoute extends _i6.PageRouteInfo<void> {
  const NavigationErrorRoute({List<_i6.PageRouteInfo>? children})
    : super(NavigationErrorRoute.name, initialChildren: children);

  static const String name = 'NavigationErrorRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.NavigationErrorPage();
    },
  );
}

/// generated route for
/// [_i2.NotFoundPage]
class NotFoundRoute extends _i6.PageRouteInfo<void> {
  const NotFoundRoute({List<_i6.PageRouteInfo>? children})
    : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.NotFoundPage();
    },
  );
}

/// generated route for
/// [_i3.PalettePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.PalettePage();
    },
  );
}

/// generated route for
/// [_i4.RootAdaptiveScreen]
class RootAdaptiveRoute extends _i6.PageRouteInfo<RootAdaptiveRouteArgs> {
  RootAdaptiveRoute({
    _i7.Key? key,
    int transitionDuration = 1000,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         RootAdaptiveRoute.name,
         args: RootAdaptiveRouteArgs(
           key: key,
           transitionDuration: transitionDuration,
         ),
         initialChildren: children,
       );

  static const String name = 'RootAdaptiveRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RootAdaptiveRouteArgs>(
        orElse: () => const RootAdaptiveRouteArgs(),
      );
      return _i4.RootAdaptiveScreen(
        key: args.key,
        transitionDuration: args.transitionDuration,
      );
    },
  );
}

class RootAdaptiveRouteArgs {
  const RootAdaptiveRouteArgs({this.key, this.transitionDuration = 1000});

  final _i7.Key? key;

  final int transitionDuration;

  @override
  String toString() {
    return 'RootAdaptiveRouteArgs{key: $key, transitionDuration: $transitionDuration}';
  }
}

/// generated route for
/// [_i5.ThemeSettingsScreen]
class ThemeSettingsRoute extends _i6.PageRouteInfo<void> {
  const ThemeSettingsRoute({List<_i6.PageRouteInfo>? children})
    : super(ThemeSettingsRoute.name, initialChildren: children);

  static const String name = 'ThemeSettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.ThemeSettingsScreen();
    },
  );
}
