import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:bloodconnect/login/1_domain/repository/login_repo.dart';
import 'package:bloodconnect/login/1_domain/usecases/usecases.dart';
import 'package:bloodconnect/service_locator.dart';
import 'package:dartz/dartz.dart';

class SigninUseCase implements UseCase<Either, UserSignInReq> {
  @override
  Future<Either> call({UserSignInReq? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}
