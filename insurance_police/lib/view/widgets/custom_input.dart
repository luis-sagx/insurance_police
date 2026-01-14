import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? icon;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
