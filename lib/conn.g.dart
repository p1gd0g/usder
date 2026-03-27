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
