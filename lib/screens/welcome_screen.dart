import 'package:flutter/material.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:lightning_chat/screens/login_screen.dart';
import 'package:lightning_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lightning_chat/widgets/rounded_button.dart';
import 'package:lightning_chat/utils/login.dart';

class WelcomeScreen extends StatefulWidget {
  static final String sName = 'welcome';
  final Duration duration;
  WelcomeScreen({Key key, this.duration}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _pageLoadingColorAnimation;
  RoundedButton loginButton, registerButton, chatButton;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      duration: widget.duration ?? Duration(seconds: 1),
      vsync: this,
    );
    _pageLoadingColorAnimation = new ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(_animationController);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    autoLogin();
  }

  void autoLogin() async {
    try {
      final _user = await login();
      if (_user != null) {
        chatButton = RoundedButton(
          title: 'Chat Now!',
          color: Colors.green,
          handlePressed: () async => await Navigator.pushNamed(
            context,
            ChatScreen.sName,
          ),
        );
      } else {
        loginButton = RoundedButton(
          title: 'Log In',
          color: Colors.deepPurple,
          handlePressed: () async => await Navigator.pushNamed(
            context,
            LoginScreen.sName,
          ),
        );
        registerButton = RoundedButton(
          title: 'Register',
          color: Colors.lightBlue,
          handlePressed: () async => await Navigator.pushNamed(
            context,
            RegistrationScreen.sName,
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageLoadingColorAnimation.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                ColorizeAnimatedTextKit(
                  text: ['Mr.Coding'],
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.yellow,
                    Colors.red,
                  ],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            loginButton ?? SizedBox(),
            registerButton ?? SizedBox(),
            chatButton ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
