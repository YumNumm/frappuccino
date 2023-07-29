import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frappuccino/core/app/app.dart';
import 'package:frappuccino/core/config/config.dart';
import 'package:frappuccino/core/env/env.dart';
import 'package:frappuccino/firebase_options.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: missing_provider_scope
  runApp(const LoadingPage());

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
    authFlowType: AuthFlowType.pkce,
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

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
