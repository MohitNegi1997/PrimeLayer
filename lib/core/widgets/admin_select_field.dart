import 'package:flutter/material.dart';

class AdminSelectOption {
  const AdminSelectOption({required this.value, required this.label});

  final String value;
  final String label;
}

class AdminSelectField extends StatelessWidget {
  const AdminSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<AdminSelectOption> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final option in options)
          DropdownMenuItem(value: option.value, child: Text(option.label)),
      ],
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}
