import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frappuccino/core/router/router.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(supabaseClientProvider);
    useEffect(
      () {
        // 初回描画完了後に処理開始
        WidgetsBinding.instance.endOfFrame.then(
          (_) {
            final session = client.auth.currentSession;
            if (session != null) {
              context.go(const HomeRoute().location);
            } else {
              context.go(const LoginRoute().location);
            }
          },
        );
        return null;
      },
      [],
    );
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
