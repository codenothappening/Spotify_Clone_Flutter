import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/sources/auth/authentication_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth.dart';
import 'package:spotify_clone/serviceLocator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signInUserReq) async {
    return await sl<AuthenticationFirebaseService>().signInUser(signInUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthenticationFirebaseService>().signUpUser(createUserReq);
  }
}
