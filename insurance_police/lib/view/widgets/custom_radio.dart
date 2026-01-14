import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  const CustomRadio({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
