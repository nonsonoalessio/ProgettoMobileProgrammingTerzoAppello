// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomsHash() => r'521a959b6a0e07c8891ef1452bd5aba0ef80ce3c';

/// See also [rooms].
@ProviderFor(rooms)
final roomsProvider = AutoDisposeProvider<Set<String>>.internal(
  rooms,
  name: r'roomsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RoomsRef = AutoDisposeProviderRef<Set<String>>;
String _$deviceNotifierHash() => r'7868d88aef6a279ed5524502e8453614d50c00ea';

/// See also [DeviceNotifier].
@ProviderFor(DeviceNotifier)
final deviceNotifierProvider =
    AutoDisposeNotifierProvider<DeviceNotifier, List<Device>>.internal(
  DeviceNotifier.new,
  name: r'deviceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deviceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeviceNotifier = AutoDisposeNotifier<List<Device>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
