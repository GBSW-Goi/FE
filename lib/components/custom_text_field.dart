import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, required this.hintText, required this.isSecure});
  final String hintText;
  final TextEditingController controller;
  final bool isSecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Color(0xffFF834E)),
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(bottom: 3),
        child: TextField(
          obscureText: isSecure,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'WantedSans',
              fontWeight: FontWeight.w200,
              color: Color(0xff757575),
              fontSize: 12
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none
            )
          ),
        ),
      ),
    );
  }
}
