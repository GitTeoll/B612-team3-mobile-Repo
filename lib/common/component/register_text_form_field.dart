import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterTextFormField extends StatelessWidget {
  final _customoutlineInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(
      Radius.circular(16.0),
    ),
  );

  final ValueKey valueKey;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool filled;
  final TextEditingController? textEditingController;
  final int maxLines;

  const RegisterTextFormField({
    super.key,
    required this.valueKey,
    required this.validator,
    required this.onSaved,
    this.hintText,
    this.inputFormatters,
    this.keyboardType,
    this.readOnly = false,
    this.filled = false,
    this.textEditingController,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: valueKey,
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: textEditingController,
      maxLines: maxLines,
      decoration: InputDecoration(
        enabledBorder: _customoutlineInputBorder,
        focusedBorder: _customoutlineInputBorder,
        errorBorder: _customoutlineInputBorder,
        focusedErrorBorder: _customoutlineInputBorder,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.all(10.0),
        fillColor: Colors.grey.shade300,
        filled: filled,
      ),
    );
  }
}
