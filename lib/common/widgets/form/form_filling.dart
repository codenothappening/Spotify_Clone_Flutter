import 'package:flutter/material.dart';
import 'package:spotify_clone/common/helpers/is_dark_mode.dart';

class FormFilling extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obsureText;
  final String? Function(String?)? validator;
  const FormFilling({
    super.key,
    required this.hintText,
    this.controller,
    this.obsureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: context.isDarkMode ? Colors.white : Colors.black,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
      ),
    );
  }
}
