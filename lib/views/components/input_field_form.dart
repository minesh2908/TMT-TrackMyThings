import 'package:flutter/material.dart';

class InputFieldForm extends StatelessWidget {
  const InputFieldForm({
    required this.fieldName,
    required this.controller,
    super.key,
    this.maxLines,
    this.icon,
    this.function,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
    this.errorText,
    this.onSubmit,
  });
  final String fieldName;

  final TextEditingController controller;
  final int? maxLines;
  final IconData? icon;
  final void Function()? function;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onSubmit;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      controller: controller,
      onTap: function,
      onChanged: onSubmit,
      decoration: InputDecoration(
        errorText: errorText,
        suffixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        alignLabelWithHint: true,
        labelText: fieldName,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        hintText: fieldName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC1CDF5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC1CDF5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
