import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    log('Provider: ${provider.name ?? provider.runtimeType}');
    log('Previous Value: $previousValue');
    log('New Value: $newValue');
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    super.didAddProvider(provider, value, container);
    log('Added Provider: ${provider.name ?? provider.runtimeType}');
    log('Initial Value: $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    super.didDisposeProvider(provider, container);
    log('Disposed Provider: ${provider.name ?? provider.runtimeType}');
  }
}
