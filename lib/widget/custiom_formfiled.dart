import 'package:flutter/material.dart';

class CustiomFormfiled extends StatelessWidget {
  CustiomFormfiled({
    super.key,
    required this.hintText,
    required this.regExpressionvalidation,
    required this.onSaved,
  });
  final String hintText;
  final RegExp regExpressionvalidation;
  final void Function(String?) onSaved;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onSaved,
      validator: (value) {
        if (value != null && regExpressionvalidation.hasMatch(value)) {
          return null;
        }
        return 'Enter a vaid ${hintText}';
      },
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
