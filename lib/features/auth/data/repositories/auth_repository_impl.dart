import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/auth_error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

/// [AuthRepository] implementation backed by Firebase Authentication.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _dataSource.signIn(
        email: email,
        password: password,
      );
      final AppUser? user = _toAppUser(credential.user);
      if (user == null) {
        return Left(AuthErrorMapper.mapCode('invalid-credential'));
      }
      return Right(user);
    } on FirebaseAuthException catch (error) {
      return Left(AuthErrorMapper.mapCode(error.code));
    } catch (error, stackTrace) {
      // Unexpected failure: preserve diagnostics in development, but never
      // expose internals to the user.
      assert(() {
        // ignore: avoid_print
        print('Unexpected sign-in failure: $error\n$stackTrace');
        return true;
      }());
      return Left(AuthErrorMapper.mapCode(null));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _dataSource.register(
        name: name,
        email: email,
        password: password,
      );
      final AppUser? user = _toAppUser(credential.user);
      if (user == null) {
        return Left(AuthErrorMapper.mapCode('invalid-credential'));
      }
      return Right(user);
    } on FirebaseAuthException catch (error) {
      return Left(AuthErrorMapper.mapCode(error.code));
    } catch (error, stackTrace) {
      assert(() {
        // ignore: avoid_print
        print('Unexpected registration failure: $error\n$stackTrace');
        return true;
      }());
      return Left(AuthErrorMapper.mapCode(null));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _dataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(AuthErrorMapper.mapCode(error.code));
    } catch (error, stackTrace) {
      assert(() {
        // ignore: avoid_print
        print('Unexpected password-reset failure: $error\n$stackTrace');
        return true;
      }());
      return Left(AuthErrorMapper.mapCode(null));
    }
  }

  @override
  Stream<AppUser?> watchAuthState() =>
      _dataSource.authStateChanges().map(_toAppUser);

  AppUser? _toAppUser(User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}
