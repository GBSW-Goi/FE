import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:programming/screens/login_screen.dart';
import 'package:programming/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final store = Store();

class Store {
  void startAnimation(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> signIn(String id, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://kairoshk.ddns.net:3333/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': id, "password": password}),
    );

    if (response.statusCode == 200) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      String tkn = data['accessToken'];
      final token = prefs.setString('token', tkn);
      print(token);
    }
  }

  Future<void> signUp(
    String name,
    String id,
    String password,
    String passwordCheck,
    String email,
    BuildContext context,
  ) async {
    final response = await http.post(
      Uri.parse('http://kairoshk.ddns.net:3333/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': id,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('회원가입에 성공하였습니다')));
    }
  }
}
