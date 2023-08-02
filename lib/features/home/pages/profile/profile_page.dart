import 'package:flutter/material.dart';
import 'package:frappuccino/features/profile/provider/profile.dart';
import 'package:frappuccino/features/profile/widget/profile_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(getProfileProvider);

    final child = Column(
      children: [
        profileState.when(
          data: (profile) => ProfileWidget(profile: profile.profile),
          error: (error, stackTrace) => Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
          loading: () => const CircularProgressIndicator.adaptive(),
        ),
      ],
    );
    return Scaffold(
      body: child,
    );
  }
}
