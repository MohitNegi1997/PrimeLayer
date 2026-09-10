import 'package:flutter/material.dart';

class AdminTextCell extends StatelessWidget {
  const AdminTextCell(this.value, {super.key, this.emphasis = false});

  final String value;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: emphasis
          ? theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            )
          : theme.textTheme.bodyMedium,
    );
  }
}
