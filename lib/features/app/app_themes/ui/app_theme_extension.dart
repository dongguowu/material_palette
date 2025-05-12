// Custom theme extension for shopping-specific colors
import 'package:flutter/material.dart';

@immutable
class ShopThemeExtension extends ThemeExtension<ShopThemeExtension> {
  final Color salePrice;
  final Color outOfStock;
  final Color newArrival;

  const ShopThemeExtension({
    required this.salePrice,
    required this.outOfStock,
    required this.newArrival,
  });

  @override
  ThemeExtension<ShopThemeExtension> copyWith({
    Color? salePrice,
    Color? outOfStock,
    Color? newArrival,
  }) {
    return ShopThemeExtension(
      salePrice: salePrice ?? this.salePrice,
      outOfStock: outOfStock ?? this.outOfStock,
      newArrival: newArrival ?? this.newArrival,
    );
  }

  @override
  ThemeExtension<ShopThemeExtension> lerp(
    ThemeExtension<ShopThemeExtension>? other,
    double t,
  ) {
    // Implementation for smooth transitions
    return this;
  }
}
