import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.maxLength,
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
  final int? maxLength;
  final bool digitOnly = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: digitOnly
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ]
          : <TextInputFormatter>[],
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
      ),
      maxLength: maxLength,
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
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        ),
        hintText: fieldName,
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        ),
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
