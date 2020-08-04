import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:lightning_chat/blocs/login_bloc/login_bloc.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:lightning_chat/screens/registration_screen.dart';
import 'package:lightning_chat/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lightning_chat/shared_widgets/rounded_button.dart';
import '../user_repository.dart';

class WelcomeScreen extends StatelessWidget {
  static final String sName = 'welcome';

  final UserRepository _userRepository;

  WelcomeScreen({
    Key key,
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LoginBloc(userRepository: _userRepository)..add(AutoLogin()),
        ),
        BlocProvider.value(
          value: BlocProvider.of<AuthenticationBloc>(context)
            ..add(AuthenticationStarted()),
        )
      ],
      child: Scaffold(
        backgroundColor: Color(0xffe3dfc8),
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
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Visibility(
                    visible: !state.isSuccess,
                    child: RoundedButton(
                      title: 'Log In',
                      color: Colors.deepPurple,
                      handlePressed: () async => await Navigator.pushNamed(
                        context,
                        LoginScreen.sName,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Visibility(
                    visible: !state.isSuccess,
                    child: RoundedButton(
                      title: 'Register',
                      color: Colors.lightBlue,
                      handlePressed: () async => await Navigator.pushNamed(
                        context,
                        RegistrationScreen.sName,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previousState, state) {
                  return state.isSuccess;
                },
                builder: (context, state) {
                  return Visibility(
                    visible: state.isSuccess,
                    child: RoundedButton(
                      title: 'Chat Now!',
                      color: Colors.green,
                      handlePressed: () async => await Navigator.pushNamed(
                        context,
                        ChatScreen.sName,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
