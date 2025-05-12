// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:material_palette/features/app/app_about/app_about.dart' as _i1;
import 'package:material_palette/features/app/app_layout/root_screen_adaptive_layout.dart'
    as _i5;
import 'package:material_palette/features/app/app_pages/navigation_error_page.dart'
    as _i2;
import 'package:material_palette/features/app/app_pages/not_found_page.dart'
    as _i3;
import 'package:material_palette/features/app/app_themes/ui/dark_switch_page.dart'
    as _i6;
import 'package:material_palette/features/palette/ui/palette_page.dart' as _i4;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i7.PageRouteInfo<void> {
  const AboutRoute({List<_i7.PageRouteInfo>? children})
    : super(AboutRoute.name, initialChildren: children);

  static const String name = 'AboutRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.NavigationErrorPage]
class NavigationErrorRoute extends _i7.PageRouteInfo<NavigationErrorRouteArgs> {
  NavigationErrorRoute({
    _i8.Key? key,
    String errorMessage = "An unknown error occurred.",
    List<_i7.PageRouteInfo>? children,
  }) : super(
         NavigationErrorRoute.name,
         args: NavigationErrorRouteArgs(key: key, errorMessage: errorMessage),
         initialChildren: children,
       );

  static const String name = 'NavigationErrorRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationErrorRouteArgs>(
        orElse: () => const NavigationErrorRouteArgs(),
      );
      return _i2.NavigationErrorPage(
        key: args.key,
        errorMessage: args.errorMessage,
      );
    },
  );
}

class NavigationErrorRouteArgs {
  const NavigationErrorRouteArgs({
    this.key,
    this.errorMessage = "An unknown error occurred.",
  });

  final _i8.Key? key;

  final String errorMessage;

  @override
  String toString() {
    return 'NavigationErrorRouteArgs{key: $key, errorMessage: $errorMessage}';
  }
}

/// generated route for
/// [_i3.NotFoundPage]
class NotFoundRoute extends _i7.PageRouteInfo<void> {
  const NotFoundRoute({List<_i7.PageRouteInfo>? children})
    : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.NotFoundPage();
    },
  );
}

/// generated route for
/// [_i4.PalettePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PalettePage();
    },
  );
}

/// generated route for
/// [_i5.RootAdaptiveScreen]
class RootAdaptiveScreenRoute
    extends _i7.PageRouteInfo<RootAdaptiveScreenRouteArgs> {
  RootAdaptiveScreenRoute({
    _i8.Key? key,
    int transitionDuration = 1000,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         RootAdaptiveScreenRoute.name,
         args: RootAdaptiveScreenRouteArgs(
           key: key,
           transitionDuration: transitionDuration,
         ),
         initialChildren: children,
       );

  static const String name = 'RootAdaptiveScreenRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RootAdaptiveScreenRouteArgs>(
        orElse: () => const RootAdaptiveScreenRouteArgs(),
      );
      return _i5.RootAdaptiveScreen(
        key: args.key,
        transitionDuration: args.transitionDuration,
      );
    },
  );
}

class RootAdaptiveScreenRouteArgs {
  const RootAdaptiveScreenRouteArgs({this.key, this.transitionDuration = 1000});

  final _i8.Key? key;

  final int transitionDuration;

  @override
  String toString() {
    return 'RootAdaptiveScreenRouteArgs{key: $key, transitionDuration: $transitionDuration}';
  }
}

/// generated route for
/// [_i6.ThemeSettingsScreen]
class ThemeSettingsRoute extends _i7.PageRouteInfo<void> {
  const ThemeSettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(ThemeSettingsRoute.name, initialChildren: children);

  static const String name = 'ThemeSettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.ThemeSettingsScreen();
    },
  );
}
