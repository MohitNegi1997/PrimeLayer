import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/widgets/admin_chip_tone.dart';

class AdminStatMetric {
  const AdminStatMetric({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    this.tone = AdminChipTone.info,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final AdminChipTone tone;
}
