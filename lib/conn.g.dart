// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conn.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conn)
final connProvider = ConnProvider._();

final class ConnProvider extends $FunctionalProvider<Conn, Conn, Conn>
    with $Provider<Conn> {
  ConnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connHash();

  @$internal
  @override
  $ProviderElement<Conn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Conn create(Ref ref) {
    return conn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Conn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Conn>(value),
    );
  }
}

String _$connHash() => r'51a9aed5b7a7623c37ee4a8f39496779d1139a8a';

@ProviderFor(rfxSpQuot)
final rfxSpQuotProvider = RfxSpQuotProvider._();

final class RfxSpQuotProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  RfxSpQuotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rfxSpQuotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rfxSpQuotHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return rfxSpQuot(ref);
  }
}

String _$rfxSpQuotHash() => r'889af77a4663472de909cdf7dc248c3f4b27a532';

@ProviderFor(usdRate)
final usdRateProvider = UsdRateProvider._();

final class UsdRateProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  UsdRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usdRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usdRateHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return usdRate(ref);
  }
}

String _$usdRateHash() => r'47905f234ce5282f07af65ea7890c35afb2cc23c';
