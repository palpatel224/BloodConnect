import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:bloodconnect/login/1_domain/repository/login_repo.dart';
import 'package:bloodconnect/login/1_domain/usecases/usecases.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase implements UseCase<Either, UserSignUpReq> {
  @override
  Future<Either> call({UserSignUpReq? params}) async {
    return await sl<AuthRepository>().signup(params!);
  }
}
