import 'package:flutter/material.dart';
import 'package:lightning_chat/screens/welcome_screen.dart';
import 'package:lightning_chat/screens/login_screen.dart';
import 'package:lightning_chat/screens/registration_screen.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
//import 'package:lightning_chat/route/router.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.sName,
      routes: {
        WelcomeScreen.sName: (context) => WelcomeScreen(),
        RegistrationScreen.sName: (context) => RegistrationScreen(),
        LoginScreen.sName: (context) => LoginScreen(),
        ChatScreen.sName: (context) => ChatScreen(),
      },
    );
  }
}
