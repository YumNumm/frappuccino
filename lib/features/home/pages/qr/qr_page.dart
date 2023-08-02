import 'package:flutter/material.dart';
import 'package:frappuccino/core/component/bordered_container.dart';
import 'package:frappuccino/features/home/pages/qr/component/qr_card.dart';
import 'package:frappuccino/features/profile/provider/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class QrPage extends HookConsumerWidget {
  const QrPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(getProfileProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: profileState.when(
            data: (profile) => Center(
              child: Column(
                children: [
                  QrCard(profile: profile.profile),
                  if (profile.profile.comeAt != null)
                    _InOutStatusWidget(
                      title: '入場',
                      dateTime: profile.profile.comeAt!,
                    ),
                  if (profile.profile.leaveAt != null)
                    _InOutStatusWidget(
                      title: '退場',
                      dateTime: profile.profile.leaveAt!,
                    ),
                ],
              ),
            ),
            error: (e, st) => Center(
              child: Text(e.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        ),
      ),
    );
  }
}

class _InOutStatusWidget extends StatelessWidget {
  const _InOutStatusWidget({
    required this.title,
    required this.dateTime,
  });

  final String title;

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BorderedContainer(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // icon
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
          const SizedBox(width: 4),
          // text
          Text(
            title,
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // date time
          Expanded(
            child: Center(
              child: Text(
                DateFormat('yyyy/MM/dd HH:mm').format(
                  dateTime.toLocal(),
                ),
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
