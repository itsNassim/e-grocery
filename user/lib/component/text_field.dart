import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool hidingPassword;
  final Color? textStyleColor;
  final String labelText;
  final Color? labelStyleColor;
  final String hintText;
  final Color? hintStyleColor;
  final bool showError;
  final IconData preIcon;
  final Color? preIconColor;
  final IconData? sufIcon;
  final Color? sufIconColor;
  final void Function()? onPressed;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hidingPassword,
    required this.textStyleColor,
    required this.labelText,
    required this.labelStyleColor,
    required this.hintText,
    required this.hintStyleColor,
    required this.showError,
    required this.preIcon,
    required this.preIconColor,
    this.sufIcon,
    this.sufIconColor,
    this.onPressed,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hidingPassword,
      style: TextStyle(color: textStyleColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelStyleColor),
        hintText: hintText,
        hintStyle: TextStyle(color: hintStyleColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: showError ? Colors.red : Color(0xFF6C1144),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: showError ? Colors.red : Color(0xFF6C1144),
            width: 2,
          ),
        ),
        prefixIcon: Icon(preIcon, color: preIconColor),
        suffixIcon: sufIcon != null
            ? IconButton(
                onPressed: onPressed,
                icon: Icon(sufIcon, color: sufIconColor),
              )
            : null,
      ),
      validator: validator,
    );
  }
}
