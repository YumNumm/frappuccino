import 'package:flutter/material.dart';
import 'package:frappuccino/features/groups/groups.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupsPage extends HookConsumerWidget {
  const GroupsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(groupsListProvider);
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Text(''),
        ),
      ),
    );
  }
}
