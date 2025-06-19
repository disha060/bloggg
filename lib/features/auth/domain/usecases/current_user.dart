import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/common/entities/user.dart';

class CurrentUser implements UseCase<User, NoParams>{
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async{
    return await authRepository.currentUser();
  }
}