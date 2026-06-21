import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  
  // login
  getIt.registerLazySingleton<AuthRepository>( () => AuthRepository());
  getIt.registerFactory<LoginCubit>( () => LoginCubit(getIt()));

  // signup
  getIt.registerFactory<SignupCubit>( () => SignupCubit(getIt()));

}