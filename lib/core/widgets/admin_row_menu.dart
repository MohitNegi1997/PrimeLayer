import 'package:flutter/material.dart';

class AdminRowMenu extends StatelessWidget {
  const AdminRowMenu({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<PopupMenuEntry<String>> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        itemBuilder: (context) => items,
      ),
    );
  }
}
