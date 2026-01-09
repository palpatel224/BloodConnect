class UserSignUpReq {
  String? name;
  String? email;
  String? password;

  UserSignUpReq(
      {required this.name, required this.email, required this.password});
}

class UserSignInReq {
  String? email;
  String? password;

  UserSignInReq({required this.email, this.password});
}
