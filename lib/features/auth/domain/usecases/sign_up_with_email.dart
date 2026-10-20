import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AppUser>> call({
    required String name,
    required String email,
    required String password,
  }) => _repository.register(
    name: name.trim(),
    email: email.trim(),
    password: password,
  );
}
