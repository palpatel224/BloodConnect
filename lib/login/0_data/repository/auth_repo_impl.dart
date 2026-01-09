import 'package:bloodconnect/login/0_data/datasources/auth_datasource.dart';
import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:bloodconnect/login/1_domain/repository/login_repo.dart';
import 'package:dartz/dartz.dart';


class AuthRepoImpl implements AuthRepository {
  final AuthFirebaseService _authFirebaseService;

  // Constructor with named parameter 'firebaseService'
  AuthRepoImpl({required AuthFirebaseService firebaseService})
      : _authFirebaseService = firebaseService;

  @override
  Future<Either<String, String>> signup(UserSignUpReq user) async {
    return await _authFirebaseService.signup(user);
  }

  @override
  Future<Either<String, String>> signin(UserSignInReq user) async {
    return await _authFirebaseService.signin(user);
  }
  
  @override
  Future<Either<String, String>> signInWithGoogle() async{
    return await _authFirebaseService.signInWithGoogle();
  }
}
