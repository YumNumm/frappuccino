import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frappuccino/core/component/bordered_container.dart';
import 'package:frappuccino/core/component/gradient_box_border.dart';
import 'package:frappuccino/core/supabase/model/db/profiles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCard extends StatelessWidget {
  const QrCard({required this.profile, super.key});

  final Profiles profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qr = FittedBox(
      fit: BoxFit.scaleDown,
      child: QrImageView(
        data: base64Encode(utf8.encode(profile.id)),
        size: 300,
        eyeStyle: QrEyeStyle(
          color: Theme.of(context).colorScheme.secondary,
          eyeShape: QrEyeShape.square,
        ),
        dataModuleStyle: QrDataModuleStyle(
          color: Theme.of(context).colorScheme.secondary,
          dataModuleShape: QrDataModuleShape.square,
        ),
      ),
    );
    // 縦書き `No. 0001`
    final counterWidget = Text(
      'No. ${profile.counter.toString().padLeft(4, '0')}',
      style: GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        shadows: [
          Shadow(
            blurRadius: 8,
            color: theme.colorScheme.secondary.withOpacity(0.3),
          ),
        ],
      ),
    );

    final name = Text(
      profile.name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
        shadows: const [
          Shadow(
            blurRadius: 1,
            color: Colors.white,
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightBlueAccent,
                Colors.deepPurple.shade800,
              ],
              stops: const [0.0, 1.0],
            ),
            width: 2,
          ),
          color: Colors.lightBlueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Card(
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.deepPurpleAccent,
                ],
                stops: [0.0, 1.0],
              ).createShader(rect);
            },
            child: Column(
              children: [
                Center(child: qr),
                const SizedBox(height: 8),
                name,
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    BorderedContainer(
                      accentColor: Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      margin: EdgeInsets.zero,
                      child: Text(
                        switch (profile.type) {
                          UserType.admin => '管理者権限',
                          UserType.groupAdmin => 'グループ管理者',
                          UserType.examinee => '受験生関連枠',
                          UserType.school => '学校関連枠',
                          UserType.general => '一般枠',
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (final i in profile.avaliableDays ?? [])
                      BorderedContainer(
                        accentColor: Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        margin: EdgeInsets.zero,
                        child: Text(
                          '$i日目枠',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                counterWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
