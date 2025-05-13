import 'package:flutter/material.dart';
import 'package:medical_app/constant.dart';

class custom_textField extends StatelessWidget {
  final String hint;
  String? email;
  String? password;
  final Function(String) onChanged;
  final bool obsecure;
  final IconData? prefixIcon;

  custom_textField({
    super.key,
    required this.hint,
    this.email,
    this.password,
    required this.onChanged,
    this.obsecure = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecure,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill the field';
        }
        return null;
      },
      style: TextStyle(
        color: kTextColor,
        fontSize: 16,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: kTextColor.withOpacity(0.7),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: kPrimaryColor,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kLightGrayColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kLightGrayColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kErrorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kErrorColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
