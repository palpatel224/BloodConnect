import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, String>> signup(UserSignUpReq user);
  Future<Either<String, String>> signin(UserSignInReq user);
  Future<Either<String,String>> signInWithGoogle();
}
