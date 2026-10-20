import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';

class SendPasswordReset {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call({required String email}) =>
      _repository.sendPasswordReset(email: email.trim());
}
