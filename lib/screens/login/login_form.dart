import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:lightning_chat/shared_widgets/rounded_button.dart';
import 'package:lightning_chat/shared_widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lightning_chat/blocs/login_bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showSpinner = false;
  TextEditingController emailController, passwordController;
  LoginBloc _loginBloc;
  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    emailController = TextEditingController()
      ..addListener(_onLoginEmailChanged);
    passwordController = TextEditingController()
      ..addListener(_onLoginPasswordChanged);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Login Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          await Navigator.pushReplacementNamed(context, ChatScreen.sName);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedTextField(
                    hintText: 'email',
                    textEditingController: emailController,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedTextField(
                    hintText: 'password.',
                    textEditingController: passwordController,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  RoundedButton(
                    title: 'Log In',
                    color: Colors.lightBlueAccent,
                    handlePressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      _onFormSubmitted();
                      setState(() {
                        emailController.clear();
                        passwordController.clear();
                        showSpinner = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
