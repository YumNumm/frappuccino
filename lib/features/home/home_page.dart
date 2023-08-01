import 'package:flutter/material.dart';
import 'package:frappuccino/core/router/router.dart';
import 'package:frappuccino/core/supabase/model/db/groups.dart';
import 'package:frappuccino/core/supabase/service/supabase_service.dart';
import 'package:frappuccino/core/supabase/supabase_client.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(frappuccinnoServiceProvider);
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
                final data = snapshot.data;
                final profile = data?.profile;
                final groups = data?.groups;
                return Column(
                  children: [
                    ListTile(
                      title: const Text('Profile'),
                      subtitle: Column(
                        children: [
                          Text('uuid: ${profile?.uuid}'),
                          Text('name: ${profile?.name}'),
                          Text('email: ${profile?.email}'),
                          Text('createdAt: ${profile?.createdAt}'),
                          Text('comeAt: ${profile?.comeAt}'),
                          Text('leaveAt: ${profile?.leaveAt}'),
                        ],
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Groups'),
                        subtitle: Column(
                          children: [
                            for (final group in groups ?? <Groups>[]) ...[
                              Text('name: ${group.name}'),
                              Text('className: ${group.className}'),
                              const Divider()
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            future: service.profileService.getMyProfile(),
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
