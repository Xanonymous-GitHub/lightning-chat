import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:lightning_chat/blocs/registration_bloc/registration_bloc.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:lightning_chat/shared_widgets/rounded_button.dart';
import 'package:lightning_chat/shared_widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationForm extends StatefulWidget {
  RegistrationForm({
    Key key,
  }) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool showSpinner = false;
  TextEditingController emailController, passwordController;
  RegisterBloc _registrationBloc;
  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _registrationBloc = BlocProvider.of<RegisterBloc>(context);
    emailController = TextEditingController()..addListener(_onEmailChanged);
    passwordController = TextEditingController()
      ..addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registrationBloc.add(
      RegisterEmailChanged(email: emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registrationBloc.add(
      RegisterPasswordChanged(password: passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registrationBloc.add(
      RegisterSubmitted(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                    title: 'Register',
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
