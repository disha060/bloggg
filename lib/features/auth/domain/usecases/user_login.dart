import 'package:bloggg/core/error/failures.dart';
import 'package:bloggg/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter/material.dart';import 'package:fpdart/fpdart.dart'; //


import '../../../../core/usecase/usecase.dart';
import '../../../../core/common/entities/user.dart';

class UserLogin implements UseCase<User,  UserLoginParams>{
  final AuthRepository authRepository;
  const UserLogin(
    this.authRepository,
);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async{
    return await authRepository.logInWithEmailPassword(email: params.email, password: params.password);
  }

}

class UserLoginParams{
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password
});
}