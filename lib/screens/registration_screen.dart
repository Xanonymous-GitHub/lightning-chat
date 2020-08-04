import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightning_chat/blocs/registration_bloc/registration_bloc.dart';
import 'package:lightning_chat/screens/registration/registration_form.dart';
import 'package:lightning_chat/user_repository.dart';

class RegistrationScreen extends StatelessWidget {
  static final String sName = 'registration';
  final UserRepository _userRepository;

  RegistrationScreen({
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
        title: Text('Registration'),
        backgroundColor: Color(0xff96bb7c),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: RegistrationForm(),
      ),
    );
  }
}
