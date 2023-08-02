import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frappuccino/features/home/pages/groups_page.dart';
import 'package:frappuccino/features/home/pages/profile/profile_page.dart';
import 'package:frappuccino/features/home/pages/qr_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Frappuccino'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: Container(
          key: ValueKey(index.value),
          child: switch (index.value) {
            0 => const QrPage(),
            1 => const GroupsPage(),
            _ => const ProfilePage(),
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => index.value = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: '入場QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
            ),
            label: '団体一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}
