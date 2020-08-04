import 'package:flutter/material.dart';
import 'package:lightning_chat/screens/welcome_screen.dart';
import 'package:lightning_chat/screens/registration_screen.dart';
import 'package:lightning_chat/screens/login_screen.dart';
import 'package:lightning_chat/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/user_repository.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.sName,
      routes: {
        WelcomeScreen.sName: (context) => WelcomeScreen(
              userRepository: _userRepository,
            ),
        RegistrationScreen.sName: (context) => RegistrationScreen(
              userRepository: _userRepository,
            ),
        LoginScreen.sName: (context) => LoginScreen(
              userRepository: _userRepository,
            ),
        ChatScreen.sName: (context) => ChatScreen(),
      },
    );
  }
}
