import 'package:flutter/material.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthenticationEvent {
  final String email;
  final String password;
  final String fullName;

  const SignUpUser(this.email, this.password, this.fullName);

  @override
  List<Object> get props => [email, password, fullName];
}

class SignInUser extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOut extends AuthenticationEvent {}
