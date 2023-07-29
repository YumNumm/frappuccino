import 'package:flutter/material.dart';
import 'package:frappuccino/core/router/router.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frappuccino'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              await ref.watch(supabaseClientProvider).auth.signOut();
            } on AuthException catch (error) {
              SnackBar(
                content: Text(error.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              );
            } catch (error) {
              SnackBar(
                content: const Text('Unexpected error occurred'),
                backgroundColor: Theme.of(context).colorScheme.error,
              );
            } finally {
              if (context.mounted) {
                context.go(const LoginRoute().location);
              }
            }
          },
          icon: const Icon(
            Icons.logout,
          ),
          label: const Text('Sign out'),
        ),
      ),
    );
  }
}
