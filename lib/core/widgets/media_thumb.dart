import 'dart:typed_data';

import 'package:flutter/material.dart';

class MediaThumb extends StatelessWidget {
  const MediaThumb({
    super.key,
    this.url,
    this.bytes,
    this.icon = Icons.image_outlined,
    this.size = 40,
    this.radius = 20,
  });

  final String? url;
  final List<int>? bytes;
  final IconData icon;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = _provider();

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: image == null
            ? CircleAvatar(
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.35,
                ),
                foregroundColor: theme.colorScheme.primary,
                child: Icon(icon, size: size * 0.5),
              )
            : Image(image: image, fit: BoxFit.cover),
      ),
    );
  }

  ImageProvider<Object>? _provider() {
    if (bytes != null && bytes!.isNotEmpty) {
      return MemoryImage(Uint8List.fromList(bytes!));
    }
    final value = url?.trim() ?? '';
    if (value.isEmpty) return null;
    return NetworkImage(value);
  }
}
