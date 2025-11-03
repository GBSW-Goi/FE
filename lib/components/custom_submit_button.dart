import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    super.key,
    required this.onTap,
    required this.buttonColor,
    required this.text,
    required this.textColor,
  });

  final VoidCallback onTap;
  final Color buttonColor;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 45,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Color(0xffFF834E)),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "WantedSans",
            fontWeight: FontWeight.w700,
            color: textColor,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}
