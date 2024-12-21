import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/auth/auth_repository.dart';
import 'package:spotify_clone/data/sources/auth/authentication_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth.dart';
import 'package:spotify_clone/domain/usecases/domain/signin.dart';
import 'package:spotify_clone/domain/usecases/domain/signup.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthenticationFirebaseService>(
    AuthenticationFirebaseServiceImp(),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );

  sl.registerSingleton<SignInUseCase>(
    SignInUseCase(),
  );
}
