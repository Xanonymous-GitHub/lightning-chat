import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/user_repository.dart';
import 'package:lightning_chat/blocs/login_bloc/login_bloc.dart';
import 'package:lightning_chat/screens/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static final String sName = 'login';
  final UserRepository _userRepository;

  LoginScreen({
    Key key,
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3dfc8),
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xff96bb7c),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(),
      ),
    );
  }
}
