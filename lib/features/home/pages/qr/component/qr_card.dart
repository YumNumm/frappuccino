import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCard extends StatelessWidget {
  const QrCard({super.key});

  @override
  Widget build(BuildContext context) {
    final qr = QrCode.fromData(
      data: 'data',
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
  }
}
