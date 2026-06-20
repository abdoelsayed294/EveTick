import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/cubit/login_cubit.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  
  // login
  getIt.registerLazySingleton<AuthRepository>( () => AuthRepository());
  getIt.registerLazySingleton<LoginCubit>( () => LoginCubit(getIt()));

}