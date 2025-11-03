import 'package:flutter/material.dart';
import 'package:programming/components/custom_submit_button.dart';
import 'package:programming/components/custom_text_field.dart';
import 'package:programming/screens/sign_up_screen.dart';

import '../store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF3E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '고이',
              style: TextStyle(
                color: Color(0xffFF834E),
                fontFamily: "Gugi",
                fontSize: 43,
              ),
            ),
            Text(
              '로그인',
              style: TextStyle(
                color: Color(0xffFF834E),
                fontFamily: "WantedSans",
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            CustomTextField(controller: idController, hintText: '아이디를 입력해주세요.', isSecure: false,),
            SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              hintText: '비밀번호를 입력해주세요.', isSecure: true,
            ),
            SizedBox(height: 30),
            CustomSubmitButton(
              onTap: () {
                store.signIn(idController.text, passwordController.text, context);
              },
              buttonColor: Color(0xffFF834E),
              text: '로그인',
              textColor: Colors.white,
            ),
            SizedBox(height: 10),
            CustomSubmitButton(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              buttonColor: Colors.white,
              text: '회원가입',
              textColor: Color(0xffFF834E),
            ),
          ],
        ),
      ),
    );
  }
}
