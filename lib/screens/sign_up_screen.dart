import 'package:flutter/material.dart';
import 'package:programming/components/custom_submit_button.dart';
import 'package:programming/components/custom_text_field.dart';

import '../store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF3E8),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xffFF834E),
                  ),
                ),
              ),
              SizedBox(height: 80),
              Column(
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
                    '회원가입',
                    style: TextStyle(
                      color: Color(0xffFF834E),
                      fontFamily: "WantedSans",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: nameController,
                    hintText: '이름을 입력해주세요.',
                    isSecure: false,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: idController,
                    hintText: '아이디를 입력해주세요.',
                    isSecure: false,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: passwordController,
                    hintText: '비밀번호를 입력해주세요.',
                    isSecure: true,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: passwordCheckController,
                    hintText: '비밀번호 확인을 입력해주세요.',
                    isSecure: true,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: emailController,
                    hintText: '이메일을 입력해주세요.',
                    isSecure: false,
                  ),
                  SizedBox(height: 30),
                  CustomSubmitButton(
                    onTap: () {
                      if (passwordController.text !=
                          passwordCheckController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
                        );
                        return;
                      }
                      if (!emailController.text.contains('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('이메일 형식이 올바르지 않습니다. 다시 확인해주세요.')),
                        );
                        return;
                      }
                      store.signUp(
                        nameController.text,
                        idController.text,
                        passwordController.text,
                        passwordCheckController.text,
                        emailController.text,
                        context,
                      );
                    },
                    buttonColor: Color(0xffFF834E),
                    text: '회원가입',
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
