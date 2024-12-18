import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/sources/auth/authentication_firebase_service.dart';
import 'package:spotify_clone/domain/entities/auth/user.dart';
import 'package:spotify_clone/presentation/mode/bloc/authenticationEvent.dart';

import 'package:spotify_clone/presentation/mode/bloc/authentication_state.dart';

import 'authenticationEvent.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationFirebaseService authService =
      AuthenticationFirebaseService();
  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authService.signUpUser(
          event.email,
          event.password,
          event.fullName,
        );
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('Create User Failed'));
        }
      } catch (e) {
        emit(AuthenticationFailureState(e.toString())); // Emit error
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignInUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authService.signInUser(
          event.email,
          event.password,
        );
        if (user != null) {
          emit(AuthenticationSuccessState(user)); // Emit success state
        } else {
          emit(const AuthenticationFailureState(
              'Invalid email or password')); // Emit failure state
        }
      } catch (e) {
        emit(const AuthenticationFailureState("Could Not find a User"));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        authService.signOutUser();
      } catch (e) {
        print("error");
        emit(AuthenticationFailureState(e.toString()));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
