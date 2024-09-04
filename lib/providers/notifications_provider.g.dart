// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsNotifierHash() =>
    r'ee4544975ecd463c93942f1389dee6294ca69c89';

/// See also [NotificationsNotifier].
@ProviderFor(NotificationsNotifier)
final notificationsNotifierProvider = AutoDisposeNotifierProvider<
    NotificationsNotifier, List<DeviceNotification>>.internal(
  NotificationsNotifier.new,
  name: r'notificationsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsNotifier = AutoDisposeNotifier<List<DeviceNotification>>;
String _$notificationCategoriesNotifierHash() =>
    r'85cfc8b3682448011f568ad215a2aec41a132209';

/// See also [NotificationCategoriesNotifier].
@ProviderFor(NotificationCategoriesNotifier)
final notificationCategoriesNotifierProvider = AutoDisposeNotifierProvider<
    NotificationCategoriesNotifier, Set<String>>.internal(
  NotificationCategoriesNotifier.new,
  name: r'notificationCategoriesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationCategoriesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationCategoriesNotifier = AutoDisposeNotifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
