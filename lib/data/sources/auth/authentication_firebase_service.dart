import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/data/models/auth/create_user_request.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/domain/entities/auth/user.dart';

abstract class AuthenticationFirebaseService {
  Future<Either> signUpUser(CreateUserReq createUserReq);
  Future<Either> signInUser(SigninUserReq signinUserReq);
}

class AuthenticationFirebaseServiceImp extends AuthenticationFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create User
  @override
  Future<Either> signUpUser(CreateUserReq createUserReq) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );
      return const Right("Signup was Successful");
    } on FirebaseException catch (e) {
      String message = '';

      if (e.code == "weak-password") {
        message = "The Password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "This email address is already been used";
      }
      return Left(message);
    }
    // SignOut User
  }

  // @override
  // Future<Either> signInUser(CreateUserReq createUserReq) async {
  //   try {
  //     final UserCredential userCredential =
  //         await _firebaseAuth.signInWithEmailAndPassword(
  //       email: createUserReq.email,
  //       password: createUserReq.email,
  //     );
  //     final User? firebaseUser = userCredential.user;
  //     if (firebaseUser != null) {
  //       UserModel(
  //         userId: firebaseUser.uid,
  //         email: firebaseUser.email ?? "",
  //         fullName: firebaseUser.displayName ?? "",
  //       );
  //       return const Right("Signin is Successful");
  //     }
  //   } on FirebaseException catch (e) {
  //     print(
  //       e.toString(),
  //     );
  //   }
  // }

  @override
  Future<Either> signInUser(SigninUserReq signinUserReq) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      return const Right("SignIn was Successful");
    } on FirebaseException catch (e) {
      String message = '';

      if (e.code == "invalid-email") {
        message = "Please Enter valid Email Address or SignUp";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid Credentials ";
      }
      return Left(message);
    }
  }

  @override
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
