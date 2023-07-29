// ignore_for_file: do_not_use_environment

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config.g.dart';

@riverpod
Config config(ConfigRef ref) {
  throw UnimplementedError();
}

// ref: https://github.com/FlutterKaigi/2023/blob/main/lib/app/config.dart
class Config {
  factory Config() {
    final flavor = Flavor.values.byName(
      const String.fromEnvironment('FLAVOR'),
    );
    return Config._(
      flavor: flavor,
    );
  }

  const Config._({
    required Flavor flavor,
  }) : _flavor = flavor;

  final Flavor _flavor;

  bool get isMock => _flavor == Flavor.dev;
}

enum Flavor {
  dev,
  prod,
}
