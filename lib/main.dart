import 'package:flutter/material.dart';
import 'package:programming/screens/intro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: IntroScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
