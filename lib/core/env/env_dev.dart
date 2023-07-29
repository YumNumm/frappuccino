// lib/env/env.dart
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final supabaseUrl = _EnvDev.supabaseUrl;
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final supabaseAnonKey = _EnvDev .supabaseAnonKey;
}
