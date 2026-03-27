// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Con)
final conProvider = ConProvider._();

final class ConProvider extends $NotifierProvider<Con, Con> {
  ConProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conHash();

  @$internal
  @override
  Con create() => Con();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Con value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Con>(value),
    );
  }
}

String _$conHash() => r'842820aaf5915f666e723f6286bc39dc5a86b19f';

abstract class _$Con extends $Notifier<Con> {
  Con build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Con, Con>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Con, Con>,
              Con,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
