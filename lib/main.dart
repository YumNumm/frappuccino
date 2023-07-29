import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frappuccino/core/app/app.dart';
import 'package:frappuccino/core/config/config.dart';
import 'package:frappuccino/core/env/env.dart';
import 'package:frappuccino/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: missing_provider_scope

  usePathUrlStrategy();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // init firebase
  final (supabaseUrl, supabaseAnonKey) = (Env.supabaseUrl, Env.supabaseAnonKey);
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
    debug: kDebugMode && Config().isMock,
  );

  // init firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final container = ProviderContainer(
    overrides: [],
  );

  runApp(
    ProviderScope(
      parent: container,
      child: const App(),
    ),
  );
}
