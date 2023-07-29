// ignore_for_file: do_not_use_environment

// ref: https://github.com/FlutterKaigi/2023/blob/main/lib/app/config.dart
class Config {
  factory Config() => instance;
  factory Config._internal() {
    final flavor = Flavor.values.byName(
      const String.fromEnvironment('FLAVOR'),
    );
    return Config._(
      flavor,
    );
  }

  Config._(this._flavor);

  // インスタンスはただ１つだけ
  static final Config instance = Config._internal();

  final Flavor _flavor;

  bool get isMock => _flavor == Flavor.dev;
}

enum Flavor {
  dev,
  prod,
}
