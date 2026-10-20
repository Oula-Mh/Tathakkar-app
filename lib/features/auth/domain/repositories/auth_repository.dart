import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';

/// Contract for authentication operations. Implemented in the data layer.
abstract interface class AuthRepository {
  /// Signs in with email/password.
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  /// Registers a new account and stores the display name on the profile.
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Sends a password-reset email to [email].
  Future<Either<Failure, Unit>> sendPasswordReset({required String email});

  /// Emits the current user on sign-in/sign-out; `null` when signed out.
  Stream<AppUser?> watchAuthState();
}
