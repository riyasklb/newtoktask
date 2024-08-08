import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField({
    super.key,
    required this.hintText,
    required this.regExpressionValidation,
    required this.onSaved,
  });
  final String hintText;
  final RegExp regExpressionValidation;
  final void Function(String?) onSaved;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onSaved,
      validator: (value) {
        if (value != null && regExpressionValidation.hasMatch(value)) {
          return null;
        }
        return 'Enter a vaid ${hintText}';
      },
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
