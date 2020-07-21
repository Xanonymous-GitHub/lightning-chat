import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lightning_chat/widgets/rounded_button.dart';
import 'package:lightning_chat/widgets/rounded_text_field.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static final String sName = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email, password;
  bool showSpinner = false;
  TextEditingController emailController, passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedTextField(
                hintText: 'Enter your email',
                textEditingController: emailController,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                keyboardType: TextInputType.emailAddress,
                handleChanged: (value) {
                  email = value.toString().trim();
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedTextField(
                hintText: 'Enter your password.',
                textEditingController: passwordController,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                obscureText: true,
                handleChanged: (value) {
                  password = value.toString().trim();
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                color: Colors.lightBlueAccent,
                handlePressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final _user = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    if (_user != null) {
                      await Navigator.pushNamed(context, ChatScreen.sName);
                    }
                  } on Exception catch (e) {
                    print(e);
                  }
                  setState(() {
                    emailController.clear();
                    passwordController.clear();
                    showSpinner = false;
                  });
                  email = null;
                  password = null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
