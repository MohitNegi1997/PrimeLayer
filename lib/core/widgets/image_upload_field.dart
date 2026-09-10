import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatelessWidget {
  const ImageUploadField({
    super.key,
    required this.label,
    this.url,
    this.bytes,
    required this.onPicked,
    required this.onCleared,
  });

  final String label;
  final String? url;
  final List<int>? bytes;
  final void Function(List<int> bytes, String name) onPicked;
  final VoidCallback onCleared;

  bool get _hasImage {
    if (bytes != null && bytes!.isNotEmpty) return true;
    return (url ?? '').trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 7,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
              color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _preview(theme),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pick(),
              icon: const Icon(Icons.upload_outlined),
              label: Text(_hasImage ? 'Replace image' : 'Upload image'),
            ),
            if (_hasImage) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onCleared,
                child: const Text('Remove'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _preview(ThemeData theme) {
    if (bytes != null && bytes!.isNotEmpty) {
      return Image.memory(Uint8List.fromList(bytes!), fit: BoxFit.cover);
    }
    final value = url?.trim() ?? '';
    if (value.isNotEmpty) {
      return Image.network(value, fit: BoxFit.cover);
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_outlined, color: theme.colorScheme.secondary),
          const SizedBox(height: 8),
          Text('No image', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final data = await file.readAsBytes();
    onPicked(data, file.name);
  }
}
