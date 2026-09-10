import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/utils/responsive.dart';

class AdminFilterBar extends StatelessWidget {
  const AdminFilterBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    final isMobile = Responsive.isMobile(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isMobile
            ? Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    children[i],
                  ],
                ],
              )
            : Row(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    i == 0
                        ? Expanded(flex: 2, child: children[i])
                        : Expanded(child: children[i]),
                  ],
                ],
              ),
      ),
    );
  }
}
