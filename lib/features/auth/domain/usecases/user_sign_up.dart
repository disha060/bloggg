import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fpdart/src/either.dart';

import '../../../../core/common/entities/user.dart';
import '../repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParams>{
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(name: params.name, email: params.email, password: params.password);
  }

}

class UserSignUpParams{
  final String email;
  final String password;
  final String name;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
});
}