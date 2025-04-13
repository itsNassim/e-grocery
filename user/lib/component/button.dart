import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final String text;
  final Color? fontColor;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.backgroundColor,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
