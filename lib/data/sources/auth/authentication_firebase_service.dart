import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/domain/entities/auth/user.dart';

class AuthenticationFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create User
  Future<UserModel?> signUpUser(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          userId: firebaseUser.uid,
          email: firebaseUser.email ?? "",
          fullName: firebaseUser.displayName ?? "",
        );
      }
    } on FirebaseException catch (e) {
      print(
        e.toString(),
      );
      return null;
    }

    // SignOut User
  }

  Future<UserModel?> signInUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          userId: firebaseUser.uid,
          email: firebaseUser.email ?? "",
          fullName: firebaseUser.displayName ?? "",
        );
      }
    } on FirebaseException catch (e) {
      print(
        e.toString(),
      );
      return null;
    }
  }

  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
