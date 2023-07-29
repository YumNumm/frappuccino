// ignore_for_file: avoid_classes_with_only_static_members

import 'package:frappuccino/core/config/config.dart';
import 'package:frappuccino/core/env/env_dev.dart';
import 'package:frappuccino/core/env/env_prod.dart';

class Env {
  static String get supabaseUrl =>
      Config().isMock ? EnvDev.supabaseUrl : EnvProd.supabaseUrl;
  static String get supabaseAnonKey =>
      Config().isMock ? EnvDev.supabaseAnonKey : EnvProd.supabaseAnonKey;
}
