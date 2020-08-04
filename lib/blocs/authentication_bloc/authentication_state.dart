part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final String userEmail, userUid;

  const AuthenticationSuccess(this.userEmail, this.userUid);

  @override
  List<Object> get props => [userEmail, userUid];
}

class AuthenticationFailure extends AuthenticationState {}
