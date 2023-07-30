import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frappuccino/core/router/router.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frappuccino'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final data = snapshot.data as List<Map<String, dynamic>>;
                return Text(const JsonEncoder.withIndent(' ').convert(data[0]));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            future: ref
                .watch(supabaseClientProvider)
                .rpc('get_profile')
                .select<List<Map<String, dynamic>>>(),
          ),
          Center(
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
        ],
      ),
    );
  }
}
