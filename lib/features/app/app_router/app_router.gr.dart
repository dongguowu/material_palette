// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:material_palette/features/app/app_pages/navigation_error_page.dart'
    as _i1;
import 'package:material_palette/features/app/app_pages/not_found_page.dart'
    as _i2;
import 'package:material_palette/features/app/app_themes/ui/dark_switch_page.dart'
    as _i4;
import 'package:material_palette/features/palette/ui/palette_page.dart' as _i3;

/// generated route for
/// [_i1.NavigationErrorPage]
class NavigationErrorRoute extends _i5.PageRouteInfo<NavigationErrorRouteArgs> {
  NavigationErrorRoute({
    _i6.Key? key,
    String errorMessage = "An unknown error occurred.",
    List<_i5.PageRouteInfo>? children,
  }) : super(
         NavigationErrorRoute.name,
         args: NavigationErrorRouteArgs(key: key, errorMessage: errorMessage),
         initialChildren: children,
       );

  static const String name = 'NavigationErrorRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NavigationErrorRouteArgs>(
        orElse: () => const NavigationErrorRouteArgs(),
      );
      return _i1.NavigationErrorPage(
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

  final _i6.Key? key;

  final String errorMessage;

  @override
  String toString() {
    return 'NavigationErrorRouteArgs{key: $key, errorMessage: $errorMessage}';
  }
}

/// generated route for
/// [_i2.NotFoundPage]
class NotFoundRoute extends _i5.PageRouteInfo<void> {
  const NotFoundRoute({List<_i5.PageRouteInfo>? children})
    : super(NotFoundRoute.name, initialChildren: children);

  static const String name = 'NotFoundRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.NotFoundPage();
    },
  );
}

/// generated route for
/// [_i3.PalettePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.PalettePage();
    },
  );
}

/// generated route for
/// [_i4.ThemeSettingsScreen]
class ThemeSettingsRoute extends _i5.PageRouteInfo<void> {
  const ThemeSettingsRoute({List<_i5.PageRouteInfo>? children})
    : super(ThemeSettingsRoute.name, initialChildren: children);

  static const String name = 'ThemeSettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.ThemeSettingsScreen();
    },
  );
}
